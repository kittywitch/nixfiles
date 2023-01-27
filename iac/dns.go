package iac

import(
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  cloudflare "github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
  "fmt"
)

func HandleDNS(ctx *pulumi.Context, config KatConfig) (zones map[string]*cloudflare.Zone, dnssec map[string]*cloudflare.ZoneDnssec, records map[string][]*cloudflare.Record, err error) {
    zones = make(map[string]*cloudflare.Zone)
    dnssec = make(map[string]*cloudflare.ZoneDnssec)
    records = make(map[string][]*cloudflare.Record)

    for name, zone := range config.Zones {
      ctx.Log.Info(fmt.Sprintf("Handling zone %s", name), nil)
      zones[name], err = zone.handle(ctx, name)
      if err != nil {
        return nil, nil, nil, err
      }
      dnssec[name], err = cloudflare.NewZoneDnssec(ctx, fmt.Sprintf("%s-dnssec", name), &cloudflare.ZoneDnssecArgs{
        ZoneId: zones[name].ID(),
      })
      if err != nil {
        return nil, nil, nil, err
      }
      for _, record := range zone.Records {
        _, exists := records[name]
        if exists {
          record_, err := record.handle(ctx, name, zones[name])
          if err != nil {
            return nil, nil, nil, err
          }
          records[name] = append(records[name], record_)
        } else {
          record_, err := record.handle(ctx, name, zones[name])
          if err != nil {
            return nil, nil, nil, err
          }
          records[name] = []*cloudflare.Record{record_}
        }
      }
    }

  return zones, dnssec, records, err
}
