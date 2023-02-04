package iac

import (
	"crypto/rand"
	"fmt"
	"github.com/pulumi/pulumi-command/sdk/go/command/remote"
	"github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
	"github.com/pulumi/pulumi-tls/sdk/v4/go/tls"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"golang.org/x/crypto/ssh"
	"net"
	"strings"
	"time"
)

type Tailnet struct {
	Devices []Device
	Zone    *Zone
}

func (t *Tailnet) handle(ctx *pulumi.Context, zone *Zone, CAKey *tls.PrivateKey, CACert *tls.SelfSignedCert) (err error) {
	t.Zone = zone
	tailnet, err := tailscale.GetDevices(ctx, &tailscale.GetDevicesArgs{}, nil)
	if err != nil {
		return err
	}
	for _, device := range tailnet.Devices {
		device_ := Device{
			Addresses: device.Addresses,
			Id:        device.Id,
			Name:      device.Name,
			Tags:      device.Tags,
			User:      device.User,
		}
		err = device_.handle(ctx, zone, CAKey, CACert)
		if err != nil {
			return err
		}
		t.Devices = append(t.Devices, device_)
	}
	return err
}

type Device struct {
	Addresses      []string
	Id             string
	Name           string
	Hostname       string
	Tailskip       string
	Tags           []string
	User           string
	Files          []*remote.Command
	Context        *pulumi.Context
	Records        []DNSRecord
	PrivateKey     *tls.PrivateKey
	TLSCertRequest *tls.CertRequest
	TLSCert        *tls.LocallySignedCert
	OSHCertificate pulumi.StringOutput
}

func (d *Device) handle(ctx *pulumi.Context, zone *Zone, CAKey *tls.PrivateKey, CACert *tls.SelfSignedCert) (err error) {
	d.Context = ctx
	d.Records = make([]DNSRecord, 0, 50)
	d.Files = make([]*remote.Command, 0, 20)
	d.Hostname = strings.Split(d.Name, ".")[0]
	d.Tailskip = fmt.Sprintf("%s.inskip.me", d.Hostname)
	if d.User != "kat@inskip.me" {
		return nil
	}
	err = d.record(zone)
	if err != nil {
		return err
	}
  if d.Hostname != "koishi" && d.Hostname != "tewi" {
    return err
  }
	err = d.handleTLS(CAKey, CACert)
	if err != nil {
		return err
	}
	err = d.handleOSH(CAKey)
	if err != nil {
		return err
	}
	return err
}

func (d *Device) handleOSH(CAKey *tls.PrivateKey) (err error) {
	d.OSHCertificate = CAKey.PrivateKeyOpenssh.ApplyT(func(CAPriv string) pulumi.StringOutput {
		OSHCertificate_ := d.PrivateKey.PrivateKeyOpenssh.ApplyT(func(UserPriv string) pulumi.String {
			CARSAPriv, err := PrivateKeyOpenSSHToRSAPrivateKey(CAPriv)
			if err != nil {
				panic(err)
			}
			signer, err := ssh.NewSignerFromKey(CARSAPriv)
			if err != nil {
				panic(err)
			}
			var cert ssh.Certificate
			cert.Nonce = make([]byte, 32)
			cert.CertType = 2
			UserRSAPriv, err := PrivateKeyOpenSSHToRSAPrivateKey(UserPriv)
			if err != nil {
				panic(err)
			}
			cert.Key, err = ssh.NewPublicKey(UserRSAPriv.Public())
			if err != nil {
				panic(err)
			}
			cert.Serial = 0
			cert.KeyId = d.Tailskip
			cert.ValidPrincipals = []string{d.Tailskip}
			cert.ValidAfter = 60
			threeMonths, err := time.ParseDuration("730h")
			if err != nil {
				panic(err)
			}
			threeMonthsInSeconds := uint64(threeMonths.Seconds())
			cert.ValidBefore = threeMonthsInSeconds
			err = cert.SignCert(rand.Reader, signer)
			return pulumi.String(string(ssh.MarshalAuthorizedKey(&cert)))
		}).(pulumi.StringOutput)
		return OSHCertificate_
	}).(pulumi.StringOutput)
	file, err := CreatePulumiFile(d.Context, fmt.Sprintf("%s-osh-cert", d.Hostname), d.Tailskip, d.OSHCertificate, []pulumi.Resource{d.PrivateKey, CAKey})
	d.Files = append(d.Files, file)
	return err
}

func (d *Device) record(zone *Zone) (err error) {
	for _, address := range d.Addresses {
		ip := net.ParseIP(address)
		kind := A
		if ip.To4() == nil {
			kind = AAAA
		}
		record := DNSRecord{
			Name:  d.Hostname,
			Kind:  kind,
			Value: ip.String(),
			Ttl:   3600,
		}
		err = record.handle(d.Context, zone)
		if err != nil {
			return err
		}
		d.Records = append(d.Records, record)
	}
	return err
}

func (d *Device) handleTLS(CAKey *tls.PrivateKey, CACert *tls.SelfSignedCert) (err error) {
	PrivateKeyDepends := []pulumi.Resource{CAKey, CACert}
	d.PrivateKey, err = tls.NewPrivateKey(d.Context, fmt.Sprintf("%s-key", d.Hostname), &tls.PrivateKeyArgs{
		Algorithm: pulumi.String("RSA"),
		RsaBits:   pulumi.Int(4096),
	}, pulumi.DependsOn(PrivateKeyDepends))
	if err != nil {
		return err
	}
	PrivateKeyDepends = append(PrivateKeyDepends, d.PrivateKey)
	file, err := CreatePulumiFile(d.Context, fmt.Sprintf("%s-pem-pk", d.Hostname), d.Tailskip, d.PrivateKey.PrivateKeyPem, PrivateKeyDepends)
	if err != nil {
		return err
	}
	d.Files = append(d.Files, file)
	file, err = CreatePulumiFile(d.Context, fmt.Sprintf("%s-osh-pk", d.Hostname), d.Tailskip, d.PrivateKey.PrivateKeyOpenssh, PrivateKeyDepends)
	if err != nil {
		return err
	}
	d.Files = append(d.Files, file)
	TLSCertRequestDepends := []pulumi.Resource{CAKey, CACert, d.PrivateKey}
	d.TLSCertRequest, err = tls.NewCertRequest(d.Context, fmt.Sprintf("%s-tls-cr", d.Hostname), &tls.CertRequestArgs{
		PrivateKeyPem: d.PrivateKey.PrivateKeyPem,
		DnsNames:      goStringArrayToPulumiStringArray([]string{d.Hostname}),
		IpAddresses:   goStringArrayToPulumiStringArray(d.Addresses),
		Subject: &tls.CertRequestSubjectArgs{
			CommonName:   pulumi.String("inskip.me"),
			Organization: pulumi.String("Kat Inskip"),
		},
	}, pulumi.DependsOn(TLSCertRequestDepends))
	if err != nil {
		return err
	}
	TLSCertDepends := []pulumi.Resource{CAKey, CACert, d.TLSCertRequest, d.PrivateKey}
	d.TLSCert, err = tls.NewLocallySignedCert(d.Context, fmt.Sprintf("%s-tls-cert", d.Hostname), &tls.LocallySignedCertArgs{
		AllowedUses: goStringArrayToPulumiStringArray([]string{"digital_signature",
			"digital_signature",
			"key_encipherment",
			"key_agreement",
			"email_protection",
		}),
		CaPrivateKeyPem:     CAKey.PrivateKeyPem,
		CaCertPem:           CACert.CertPem,
		CertRequestPem:      d.TLSCertRequest.CertRequestPem,
		ValidityPeriodHours: pulumi.Int(1440),
		EarlyRenewalHours:   pulumi.Int(168),
	}, pulumi.DependsOn(TLSCertDepends))
	file, err = CreatePulumiFile(d.Context, fmt.Sprintf("%s-pem-cert", d.Hostname), d.Tailskip, d.TLSCert.CertPem, TLSCertDepends)
	d.Files = append(d.Files, file)
	if err != nil {
		return err
	}
	return err
}
