package iac

import (
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  tls "github.com/pulumi/pulumi-tls/sdk/v4/go/tls"
  "fmt"
)

func generateKeyPair(ctx *pulumi.Context,
  purpose string,
  ca_key *tls.PrivateKey,
  ca_cert *tls.SelfSignedCert,
  dns_names []string,
  ip_addresses []string) (key *tls.PrivateKey,
  cr *tls.CertRequest,
  cert *tls.LocallySignedCert,
  err error) {
  key, err = tls.NewPrivateKey(ctx, fmt.Sprintf("%s-key", purpose), &tls.PrivateKeyArgs{
    Algorithm: pulumi.String("RSA"),
    RsaBits: pulumi.Int(4096),
  })
  if err != nil {
    return nil, nil, nil, err
  }
  cr, err = tls.NewCertRequest(ctx, fmt.Sprintf("%s-cr", purpose), &tls.CertRequestArgs{
    PrivateKeyPem: key.PrivateKeyPem,
    DnsNames: goStringArrayToPulumiStringArray(dns_names),
    IpAddresses: goStringArrayToPulumiStringArray(ip_addresses),
    Subject: &tls.CertRequestSubjectArgs{
      CommonName: pulumi.String("inskip.me"),
      Organization: pulumi.String("Kat Inskip"),
    },
  })
  if err != nil {
    return nil, nil, nil, err
  }
  cert, err = tls.NewLocallySignedCert(ctx, fmt.Sprintf("%s-cert", purpose), &tls.LocallySignedCertArgs{
    AllowedUses: goStringArrayToPulumiStringArray([]string{"digital_signature",
      "digital_signature",
      "key_encipherment",
      "key_agreement",
      "email_protection",
    }),
    CaPrivateKeyPem: ca_key.PrivateKeyPem,
    CaCertPem: ca_cert.CertPem,
    CertRequestPem: cr.CertRequestPem,
    ValidityPeriodHours: pulumi.Int(1440),
    EarlyRenewalHours: pulumi.Int(168),
  })
  if err != nil {
    return nil, nil, nil, err
  }
  return key, cr, cert, err
}
