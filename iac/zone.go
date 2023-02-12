package iac

import (
	cloudflare "github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"strings"
)

type Zone struct {
	Context      *pulumi.Context
	Alias        string
	Zone         string      `yaml:"name"`
	ExtraRecords []DNSRecord `yaml:"records"`
	CFZone       *cloudflare.Zone
	Devices      []Device
	CertAuth     CertificateAuthority
	DNSSec       *cloudflare.ZoneDnssec
}

func (z *Zone) Handle(ctx *pulumi.Context) (err error) {
	z.Context = ctx
	z.Alias = strings.ReplaceAll(z.Zone, ".", "-")
	z.CFZone, err = cloudflare.NewZone(ctx, z.Alias, &cloudflare.ZoneArgs{
		AccountId: pulumi.ID("0467b993b65d8fd4a53fe24ed2fbb2a1"),
		Zone:      pulumi.String(z.Zone),
		Plan:      pulumi.String("free"),
	})
	if err != nil {
		return err
	}
	if z.Alias == "inskip-me" {
		z.CertAuth = CertificateAuthority{}
		err = z.CertAuth.handle(ctx)
		if err != nil {
			return err
		}
		err = z.handleTailscale()
		if err != nil {
			return err
		}
	}
	for _, record := range z.ExtraRecords {
		err = record.handle(ctx, z)
	}
	err = z.dnssec()
	return err
}

func (z *Zone) dnssec() (err error) {
	z.DNSSec, err = cloudflare.NewZoneDnssec(z.Context, z.Alias, &cloudflare.ZoneDnssecArgs{
		ZoneId: z.CFZone.ID(),
	})
	if err != nil {
		return err
	}
	return err
}

func (z *Zone) handleTailscale() (err error) {
	tailnet := Tailnet{}
	err = tailnet.handle(z.Context, z, z.CertAuth.Key, z.CertAuth.Cert)
	if err != nil {
		return err
	}
	z.Devices = tailnet.Devices
	return err
}
