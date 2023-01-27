package main

import (
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  tailscale "github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
  "gopkg.in/yaml.v3"
  "log"
  "os"
  iac "kittywitch/iac"
)

func main() {
  katConfig := iac.KatConfig{}

  configFile, err := os.ReadFile("config.yaml")

  if err != nil {
    log.Fatal(err)
  }

  if err := yaml.Unmarshal(configFile, &katConfig); err != nil {
    log.Fatal(err)
  }

  pulumi.Run(func(ctx *pulumi.Context) error {
    tailnet, err := tailscale.GetDevices(ctx, &tailscale.GetDevicesArgs{}, nil)
    if err != nil {
      return err
    }

    // zones, dnssec, records
    zones, _, records, err := iac.HandleDNS(ctx, katConfig)

    if err != nil {
      log.Fatal(err)
    }

    records, err = iac.HandleTSRecords(ctx, tailnet, zones, records)

    if err != nil {
      log.Fatal(err)
    }

    ca_key, ca_cert, err := iac.GenerateTLSCA(ctx)

    if err != nil {
      log.Fatal(err)
    }

    // keys, crs, certs
    _, _, _, err = iac.HandleTSHostCerts(ctx, tailnet, ca_key, ca_cert)

    if err != nil {
      log.Fatal(err)
    }
    return nil
  })
}
