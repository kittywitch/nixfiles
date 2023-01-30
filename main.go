package main

import (
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  "github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
  "gopkg.in/yaml.v3"
  "os"
  "kittywitch/iac"
  "github.com/pulumi/pulumi-command/sdk/go/command/local"
)

func main() {
  katConfig := iac.KatConfig{}

  configFile, err := os.ReadFile("config.yaml")

  if err != nil {
    return
  }

  if err := yaml.Unmarshal(configFile, &katConfig); err != nil {
    return
  }

  pulumi.Run(func(ctx *pulumi.Context) error {
    tailnet, err := tailscale.GetDevices(ctx, &tailscale.GetDevicesArgs{}, nil)
    if err != nil {
      return err
    }

    // zones, dnssec, records
    zones, _, records, err := iac.HandleDNS(ctx, katConfig)

    if err != nil {
      return err
    }

    records, err = iac.HandleTSRecords(ctx, tailnet, zones, records)

    if err != nil {
      return err
    }

    ca_key, ca_cert, err := iac.GenerateTLSCA(ctx)

    if err != nil {
      return err
    }

    keys, _, certs, err := iac.HandleTSHostCerts(ctx, tailnet, ca_key, ca_cert)

    if err != nil {
      return err
    }

    // files for those certs

    files := make(map[string]*local.Command)

    files, err = iac.PKITLSFiles(ctx, files, keys, certs)

    if err != nil {
      return err
    }

    return err
  })
}
