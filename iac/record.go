package iac

import (
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  cloudflare "github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
  "github.com/creasty/defaults"
  "fmt"
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

func (r *DNSRecord) getZone(Zone *cloudflare.Zone) (pulumi.StringOutput) {
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
