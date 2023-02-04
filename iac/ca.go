package iac

import (
	tls "github.com/pulumi/pulumi-tls/sdk/v4/go/tls"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

type CertificateAuthority struct {
	Key  *tls.PrivateKey
	Cert *tls.SelfSignedCert
}

func (ca *CertificateAuthority) handle(ctx *pulumi.Context) (err error) {
	ca.Key, err = tls.NewPrivateKey(ctx, "ca-root", &tls.PrivateKeyArgs{
		Algorithm: pulumi.String("RSA"),
		RsaBits:   pulumi.Int(4096),
	})

	if err != nil {
		return err
	}

	ca.Cert, err = tls.NewSelfSignedCert(ctx, "ca-root", &tls.SelfSignedCertArgs{
		PrivateKeyPem: ca.Key.PrivateKeyPem,
		AllowedUses: goStringArrayToPulumiStringArray([]string{"digital_signature",
			"cert_signing",
			"crl_signing"}),
		IsCaCertificate:     pulumi.Bool(true),
		ValidityPeriodHours: pulumi.Int(2562047),
		Subject: &tls.SelfSignedCertSubjectArgs{
			CommonName:   pulumi.String("inskip.me"),
			Organization: pulumi.String("Kat Inskip"),
		},
	})

	if err != nil {
		return err
	}

	ctx.Export("ca_pem_privkey", ca.Key.PrivateKeyPem)
	ctx.Export("ca_os_privkey", ca.Key.PrivateKeyOpenssh)
	ctx.Export("ca_pem_cert", ca.Cert.CertPem)

	return err
}
