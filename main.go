package main

import (
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  tailscale "github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
  cloudflare "github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
  "gopkg.in/yaml.v3"
  "github.com/creasty/defaults"
  "log"
  "fmt"
  "os"
  "strings"
  "crypto/md5"
  "encoding/hex"
)

type DNSRecordType string

const (
  A DNSRecordType = "a"
  AAAA = "aaaa"
  MX = "mx"
  TXT = "txt"
  CAA = "caa"
)

type DNSRecord struct {
  Name string `default:"@" yaml:"name"`
  Kind DNSRecordType `yaml:"kind"`
  Value string `yaml:"value,omitempty"`
  Priority int `yaml:"priority,omitempty"`
  Flags string `yaml:"flags,omitempty"`
  Tag string `yaml:"tag,omitempty"`
  Ttl int `default:"3600" yaml:"ttl,omitempty"`
}

func (r *DNSRecord) UnmarshalYAML(unmarshal func(interface{}) error) error {
    defaults.Set(r)

    type plain DNSRecord
    if err := unmarshal((*plain)(r)); err != nil {
        return err
    }

    return nil
}

func (r *DNSRecord) getZone( Zone *cloudflare.Zone) (pulumi.StringOutput) {
  return Zone.ID().ToStringOutput()
}

func (r *DNSRecord) getName(ZoneName string, Zone *cloudflare.Zone) (string) {
  base := fmt.Sprintf("%s-%s-%s", ZoneName, r.Kind, r.Name)

  hash := md5.Sum([]byte(r.Value))
  hashString := hex.EncodeToString(hash[:])[:5]
  suffix := ""
  switch r.Kind {
    case MX:
      suffix = fmt.Sprintf("-%d-%s", r.Priority, hashString)
    case CAA:
      suffix = fmt.Sprintf("%s-%s", r.Flags, r.Tag)
    case A, AAAA, TXT:
      suffix = fmt.Sprintf("-%s", hashString)
  }

  built := base + suffix
  return built
}

func (r *DNSRecord) handle(ctx *pulumi.Context, ZoneName string, zone *cloudflare.Zone) (*cloudflare.Record, error) {
  var recordArgs *cloudflare.RecordArgs
  switch r.Kind {
    case CAA:
      recordArgs = &cloudflare.RecordArgs{
        ZoneId: r.getZone(zone),
        Name: pulumi.String(r.Name),
        Type: pulumi.String(strings.ToUpper(string(r.Kind))),
        Ttl: pulumi.Int(r.Ttl),
        Data: &cloudflare.RecordDataArgs{
          Flags: pulumi.String(r.Flags),
          Tag: pulumi.String(r.Tag),
          Value: pulumi.String(r.Value),
        },
      }
    default:
      recordArgs = &cloudflare.RecordArgs{
        ZoneId: r.getZone(zone),
        Name: pulumi.String(r.Name),
        Type: pulumi.String(strings.ToUpper(string(r.Kind))),
        Ttl: pulumi.Int(r.Ttl),
        Priority: pulumi.Int(r.Priority),
        Value: pulumi.String(r.Value),
      }
  }
  return cloudflare.NewRecord(ctx, r.getName(ZoneName, zone), recordArgs)
}

type Zone struct {
  Zone string `yaml:"name"`
  Records []DNSRecord `yaml:"records"`
}

type Config struct {
  Zones map[string]Zone `yaml:"zones"`
}

func (z *Zone) handle(ctx *pulumi.Context, name string) (*cloudflare.Zone, error) {
  return cloudflare.NewZone(ctx, name, &cloudflare.ZoneArgs{
    Zone: pulumi.String(z.Zone),
    Plan: pulumi.String("free"),
  })
}

func main() {
  config := Config{}

  configfile, err := os.ReadFile("config.yaml")
  if err != nil {
    log.Fatal(err)
  }
  if err := yaml.Unmarshal(configfile, &config); err != nil {
    log.Fatal(err)
  }

  pulumi.Run(func(ctx *pulumi.Context) error {
    ctx.Log.Info(fmt.Sprintf("%v\n", config), nil)
    tailnet, err := tailscale.GetDevices(ctx, &tailscale.GetDevicesArgs{}, nil)
    if err != nil {
      return err
    }
    zones := make(map[string]*cloudflare.Zone)
    dnssec := make(map[string]*cloudflare.ZoneDnssec)
    records := make(map[string][]*cloudflare.Record)
    for name, zone := range config.Zones {
      ctx.Log.Info(name, nil)
      zones[name], err = zone.handle(ctx, name)
      if err != nil {
        return err
      }
      dnssec[name], err = cloudflare.NewZoneDnssec(ctx, fmt.Sprintf("%s-dnssec", name), &cloudflare.ZoneDnssecArgs{
        ZoneId: zones[name].ID(),
      })
      if err != nil {
        return err
      }
      for _, record := range zone.Records {
        _, exists := records[name]
        if exists {
          record_, err := record.handle(ctx, name, zones[name])
          if err != nil {
            log.Fatal(err)
          }
          records[name] = append(records[name], record_)
        } else {
          record_, err := record.handle(ctx, name, zones[name])
          if err != nil {
            log.Fatal(err)
          }
          records[name] = []*cloudflare.Record{record_}
        }
      }
    }

    for _, device := range tailnet.Devices {
      if device.User != "kat@inskip.me" {
        continue
      }
      device_name := strings.Split(device.Name, ".")[0]
      ipv4 := DNSRecord{
        Name: device_name,
        Kind: A,
        Value: device.Addresses[0],
        Ttl: 3600,
      }
      recv4, err := ipv4.handle(ctx, "inskip", zones["inskip"])
      if err != nil {
        log.Fatal(err)
      }
      ipv6 := DNSRecord{
        Name: device_name,
        Kind: AAAA,
        Value: device.Addresses[1],
        Ttl: 3600,
      }
      recv6, err := ipv6.handle(ctx, "inskip", zones["inskip"])
      if err != nil {
        log.Fatal(err)
      }
      records["inskip"] = append(records["inskip"], recv4, recv6)
    }

      if err != nil {
        log.Fatal(err)
      }
		return nil
	})
}
