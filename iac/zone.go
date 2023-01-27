package iac

import (
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  cloudflare "github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
)

type Zone struct {
  Zone string `yaml:"name"`
  Records []DNSRecord `yaml:"records"`
}

func (z *Zone) handle(ctx *pulumi.Context, name string) (zone *cloudflare.Zone, err error) {
  zone, err = cloudflare.NewZone(ctx, name, &cloudflare.ZoneArgs{
    AccountId: pulumi.ID("0467b993b65d8fd4a53fe24ed2fbb2a1"),
    Zone: pulumi.String(z.Zone),
    Plan: pulumi.String("free"),
  })
  if err != nil {
    return nil, err
  }
  return zone, err
}

