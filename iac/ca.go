package iac

import(
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  tls "github.com/pulumi/pulumi-tls/sdk/v4/go/tls"
)

func GenerateTLSCA(ctx *pulumi.Context) (key *tls.PrivateKey, cert *tls.SelfSignedCert, err error) {
    key, err = tls.NewPrivateKey(ctx, "kat-root-ca-key", &tls.PrivateKeyArgs{
      Algorithm: pulumi.String("RSA"),
      RsaBits: pulumi.Int(4096),
    })

    if err != nil {
      return nil, nil, err
    }

    cert, err = tls.NewSelfSignedCert(ctx, "kat-root-ca-pem-cert", &tls.SelfSignedCertArgs{
      PrivateKeyPem: key.PrivateKeyPem,
      AllowedUses: goStringArrayToPulumiStringArray([]string{"digital_signature",
                    "cert_signing",
                    "crl_signing"}),
      IsCaCertificate: pulumi.Bool(true),
      ValidityPeriodHours: pulumi.Int(2562047),
      Subject: &tls.SelfSignedCertSubjectArgs{
        CommonName: pulumi.String("inskip.me"),
        Organization: pulumi.String("Kat Inskip"),
      },
    })

    if err != nil {
      return nil, nil, err
    }

    ctx.Export("tls_ca_pem_key", key.PrivateKeyPem)
    ctx.Export("tls_ca_os_key", key.PrivateKeyOpenssh)
    ctx.Export("tls_ca_cert", cert.CertPem)

    return key, cert, err
}
