package iac

import (
	"fmt"
	"net"
	"strings"

	oshpr "github.com/kittywitch/provider-opensshcertificate/sdk/go/provider"
	osh "github.com/kittywitch/provider-opensshcertificate/sdk/go/provider/provider"
	"github.com/pulumi/pulumi-command/sdk/go/command/remote"
	"github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
	"github.com/pulumi/pulumi-tls/sdk/v4/go/tls"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
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
	Addresses                 []string
	Id                        string
	Name                      string
	Hostname                  string
	Tailskip                  string
	Tags                      []string
	User                      string
	Files                     []*remote.Command
	Context                   *pulumi.Context
	Records                   []DNSRecord
	PrivateKey                *tls.PrivateKey
	PrivateKeyED25519         *tls.PrivateKey
	PrivateKeyUser            *tls.PrivateKey
	PrivateKeyED25519User     *tls.PrivateKey
	TLSCertRequest            *tls.CertRequest
	TLSCert                   *tls.LocallySignedCert
	OSHCertificate            *osh.OpenSSHCertificate
	OSHCertificateED25519     *osh.OpenSSHCertificate
	OSHCertificateUser        pulumi.StringOutput
	OSHCertificateED25519User pulumi.StringOutput
	OSHCACert                 pulumi.StringOutput
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
	d.OSHCACert = CAKey.PublicKeyOpenssh
	file, err := CreatePulumiFile(d.Context, fmt.Sprintf("%s-osh-ca-cert", d.Hostname), d.Tailskip, pulumi.Sprintf("@certificate-authority * %s", d.OSHCACert), []pulumi.Resource{CAKey})
	d.Files = append(d.Files, file)
	oshProvider, err := oshpr.NewProvider(d.Context, fmt.Sprintf("%s-oshmew", d.Hostname), &oshpr.ProviderArgs{})

	if err != nil {
		return err
	}
	/* 	func NewOpenSSHCertificate(ctx *pulumi.Context,
	   	name string, args *OpenSSHCertificateArgs, opts ...pulumi.ResourceOption) (*OpenSSHCertificate, error) {

	   	Algorithm pulumi.StringOutput `pulumi:"algorithm"`
	   	Cakey     pulumi.StringOutput `pulumi:"cakey"`
	   	Content   pulumi.StringOutput `pulumi:"content"`
	   	Duration  pulumi.StringOutput `pulumi:"duration"`
	   	Hostname  pulumi.StringOutput `pulumi:"hostname"`
	   	Kind      pulumi.StringOutput `pulumi:"kind"`
	   	Userkey   pulumi.StringOutput `pulumi:"userkey"`
	*/
	d.OSHCertificate, err = osh.NewOpenSSHCertificate(d.Context, fmt.Sprintf("%s-osh-cert", d.Hostname), &osh.OpenSSHCertificateArgs{
		Algorithm: pulumi.String("rsa"),
		Cakey:     CAKey.PrivateKeyOpenssh,
		Duration:  pulumi.String("730h"),
		Hostname:  pulumi.String(d.Tailskip),
		Kind:      pulumi.String("host"),
		Userkey:   d.PrivateKey.PrivateKeyOpenssh,
	}, pulumi.Provider(oshProvider))
	if err != nil {
		return err
	}
	d.OSHCertificateED25519, err = osh.NewOpenSSHCertificate(d.Context, fmt.Sprintf("%s-osh-cert-ed25519", d.Hostname), &osh.OpenSSHCertificateArgs{
		Algorithm: pulumi.String("ed25519"),
		Cakey:     CAKey.PrivateKeyOpenssh,
		Duration:  pulumi.String("730h"),
		Hostname:  pulumi.String(d.Tailskip),
		Kind:      pulumi.String("host"),
		Userkey:   d.PrivateKey.PrivateKeyOpenssh,
	}, pulumi.Provider(oshProvider))
	if err != nil {
		return err
	}

	file, err = CreatePulumiFile(d.Context, fmt.Sprintf("%s-osh-cert", d.Hostname), d.Tailskip, d.OSHCertificate.Content, []pulumi.Resource{d.PrivateKey, CAKey})
	d.Files = append(d.Files, file)
	file, err = CreatePulumiFile(d.Context, fmt.Sprintf("%s-osh-ed25519-cert", d.Hostname), d.Tailskip, d.OSHCertificateED25519.Content, []pulumi.Resource{d.PrivateKeyED25519, CAKey})
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

	d.PrivateKeyUser, err = tls.NewPrivateKey(d.Context, fmt.Sprintf("%s-user-key", d.Hostname), &tls.PrivateKeyArgs{
		Algorithm: pulumi.String("RSA"),
		RsaBits:   pulumi.Int(4096),
	}, pulumi.DependsOn(PrivateKeyDepends))

	if err != nil {
		return err
	}

	d.PrivateKeyED25519, err = tls.NewPrivateKey(d.Context, fmt.Sprintf("%s-ed25519-key", d.Hostname), &tls.PrivateKeyArgs{
		Algorithm: pulumi.String("ED25519"),
		RsaBits:   pulumi.Int(4096),
	}, pulumi.DependsOn(PrivateKeyDepends))

	if err != nil {
		return err
	}
	d.PrivateKeyED25519User, err = tls.NewPrivateKey(d.Context, fmt.Sprintf("%s-ed25519-user-key", d.Hostname), &tls.PrivateKeyArgs{
		Algorithm: pulumi.String("ED25519"),
		RsaBits:   pulumi.Int(4096),
	}, pulumi.DependsOn(PrivateKeyDepends))

	if err != nil {
		return err
	}
	PrivateKeyED25519Depends := append(PrivateKeyDepends, d.PrivateKeyED25519)
	PrivateKeyDepends = append(PrivateKeyDepends, d.PrivateKey)
	PrivateKeyED25519UserDepends := append(PrivateKeyDepends, d.PrivateKeyED25519User)
	PrivateKeyUserDepends := append(PrivateKeyDepends, d.PrivateKeyUser)

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
	file, err = CreatePulumiFile(d.Context, fmt.Sprintf("%s-osh-user-pk", d.Hostname), d.Tailskip, d.PrivateKeyUser.PrivateKeyOpenssh, PrivateKeyUserDepends)
	if err != nil {
		return err
	}
	d.Files = append(d.Files, file)
	file, err = CreatePulumiFile(d.Context, fmt.Sprintf("%s-ed25519-osh-pk", d.Hostname), d.Tailskip, d.PrivateKeyED25519.PrivateKeyOpenssh, PrivateKeyED25519Depends)
	if err != nil {
		return err
	}
	d.Files = append(d.Files, file)
	file, err = CreatePulumiFile(d.Context, fmt.Sprintf("%s-ed25519-osh-user-pk", d.Hostname), d.Tailskip, d.PrivateKeyED25519User.PrivateKeyOpenssh, PrivateKeyED25519UserDepends)
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
