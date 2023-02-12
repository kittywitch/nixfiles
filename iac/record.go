package iac

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"github.com/creasty/defaults"
	"github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"strings"
)

type DNSRecordType string

type HigherType uint16

const (
	A        DNSRecordType = "a"
	AAAA                   = "aaaa"
	MX                     = "mx"
	TXT                    = "txt"
	CAA                    = "caa"
	CNAME                  = "cname"
	IDOutput HigherType    = 0
	RawValue               = 1
	String                 = 2
)

type DNSRecord struct {
	CFRecord *cloudflare.Record
	Zone     *Zone
	Higher   HigherType    `default:"0""`
	Name     string        `default:"@" yaml:"name"`
	Kind     DNSRecordType `yaml:"kind"`
	RawValue pulumi.StringOutput
	Value    string `yaml:"value,omitempty"`
	Priority int    `yaml:"priority,omitempty"`
	Flags    string `yaml:"flags,omitempty"`
	Tag      string `yaml:"tag,omitempty"`
	Ttl      int    `default:"3600" yaml:"ttl,omitempty"`
}

func (r *DNSRecord) UnmarshalYAML(unmarshal func(interface{}) error) (err error) {
	err = defaults.Set(r)

	if err != nil {
		return err
	}

	type plain DNSRecord
	if err := unmarshal((*plain)(r)); err != nil {
		return err
	}

	return err
}

func (r *DNSRecord) getZone() pulumi.IDOutput {
	return r.Zone.CFZone.ID()
}

func (r *DNSRecord) getName() string {
	var base string
	var hash [16]byte
	if r.Higher == 0 {
		base = fmt.Sprintf("%s-%s-%s", r.Zone.Alias, r.Kind, r.Name)
		hash = md5.Sum([]byte(r.Value))
	} else {
		base = fmt.Sprintf("%s-%s", r.Kind, r.Name)
		hash = md5.Sum([]byte(r.Name))
	}

	hashString := hex.EncodeToString(hash[:])[:5]
	suffix := ""
	switch r.Kind {
	case MX:
		suffix = fmt.Sprintf("-%d-%s", r.Priority, hashString)
	case CAA:
		suffix = fmt.Sprintf("%s-%s", r.Flags, r.Tag)
	case A, AAAA, TXT, CNAME:
		suffix = fmt.Sprintf("-%s", hashString)
	}

	built := base + suffix
	return built
}

func (r *DNSRecord) handleOutput(ctx *pulumi.Context, zone *Zone) (err error) {
	r.Zone = zone
	var recordArgs *cloudflare.RecordArgs
	switch r.Kind {
	case CAA:
		recordArgs = &cloudflare.RecordArgs{
			ZoneId: r.Zone.CFZone.ID(),
			Name:   pulumi.String(r.Name),
			Type:   pulumi.String(strings.ToUpper(string(r.Kind))),
			Ttl:    pulumi.Int(r.Ttl),
			Data: &cloudflare.RecordDataArgs{
				Flags: pulumi.String(r.Flags),
				Tag:   pulumi.String(r.Tag),
				Value: r.RawValue,
			},
		}
	default:
		recordArgs = &cloudflare.RecordArgs{
			ZoneId:   r.Zone.CFZone.ID(),
			Name:     pulumi.String(r.Name),
			Type:     pulumi.String(strings.ToUpper(string(r.Kind))),
			Ttl:      pulumi.Int(r.Ttl),
			Priority: pulumi.Int(r.Priority),
			Value:    r.RawValue,
		}
	}
	r.CFRecord, err = cloudflare.NewRecord(ctx, r.getName(), recordArgs, pulumi.DependsOn([]pulumi.Resource{r.Zone.CFZone}))
	return err
}

func (r *DNSRecord) handle(ctx *pulumi.Context, zone *Zone) (err error) {
	r.Zone = zone
	cfzone := zone.CFZone
	return r.handleCF(ctx, cfzone)
}

func (r *DNSRecord) handleCF(ctx *pulumi.Context, zone *cloudflare.Zone) (err error) {
	zoneID := zone.ID()
	depends := pulumi.DependsOn([]pulumi.Resource{zone})
	return r.handleID(ctx, zoneID, depends)
}

func (r *DNSRecord) handleValue(ctx *pulumi.Context, zone *cloudflare.LookupZoneResult) (err error) {
	var recordArgs *cloudflare.RecordArgs
	switch r.Kind {
	case CAA:
		recordArgs = &cloudflare.RecordArgs{
			ZoneId: pulumi.String(zone.ZoneId),
			Name:   pulumi.String(r.Name),
			Type:   pulumi.String(strings.ToUpper(string(r.Kind))),
			Ttl:    pulumi.Int(r.Ttl),
			Data: &cloudflare.RecordDataArgs{
				Flags: pulumi.String(r.Flags),
				Tag:   pulumi.String(r.Tag),
				Value: r.RawValue,
			},
		}
	default:
		recordArgs = &cloudflare.RecordArgs{
			ZoneId:   pulumi.String(zone.ZoneId),
			Name:     pulumi.String(r.Name),
			Type:     pulumi.String(strings.ToUpper(string(r.Kind))),
			Ttl:      pulumi.Int(r.Ttl),
			Priority: pulumi.Int(r.Priority),
			Value:    r.RawValue,
		}
	}
	r.CFRecord, err = cloudflare.NewRecord(ctx, r.getName(), recordArgs)
	return err
}

func (r *DNSRecord) handleID(ctx *pulumi.Context, zoneID pulumi.IDOutput, depends pulumi.ResourceOption) (err error) {
	var recordArgs *cloudflare.RecordArgs
	switch r.Kind {
	case CAA:
		recordArgs = &cloudflare.RecordArgs{
			ZoneId: zoneID,
			Name:   pulumi.String(r.Name),
			Type:   pulumi.String(strings.ToUpper(string(r.Kind))),
			Ttl:    pulumi.Int(r.Ttl),
			Data: &cloudflare.RecordDataArgs{
				Flags: pulumi.String(r.Flags),
				Tag:   pulumi.String(r.Tag),
				Value: pulumi.String(r.Value),
			},
		}
	default:
		recordArgs = &cloudflare.RecordArgs{
			ZoneId:   zoneID,
			Name:     pulumi.String(r.Name),
			Type:     pulumi.String(strings.ToUpper(string(r.Kind))),
			Ttl:      pulumi.Int(r.Ttl),
			Priority: pulumi.Int(r.Priority),
			Value:    pulumi.String(r.Value),
		}
	}
	r.CFRecord, err = cloudflare.NewRecord(ctx, r.getName(), recordArgs, depends)
	return err
}
