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

const (
	A     DNSRecordType = "a"
	AAAA                = "aaaa"
	MX                  = "mx"
	TXT                 = "txt"
	CAA                 = "caa"
	CNAME               = "cname"
)

type DNSRecord struct {
	CFRecord *cloudflare.Record
	Zone     *Zone
	Name     string        `default:"@" yaml:"name"`
	Kind     DNSRecordType `yaml:"kind"`
	Value    string        `yaml:"value,omitempty"`
	Priority int           `yaml:"priority,omitempty"`
	Flags    string        `yaml:"flags,omitempty"`
	Tag      string        `yaml:"tag,omitempty"`
	Ttl      int           `default:"3600" yaml:"ttl,omitempty"`
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

func (r *DNSRecord) getZone() pulumi.StringOutput {
	return r.Zone.CFZone.ID().ToStringOutput()
}

func (r *DNSRecord) getName() string {
	base := fmt.Sprintf("%s-%s-%s", r.Zone.Alias, r.Kind, r.Name)

	hash := md5.Sum([]byte(r.Value))
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

func (r *DNSRecord) handle(ctx *pulumi.Context, zone *Zone) (err error) {
	r.Zone = zone
	var recordArgs *cloudflare.RecordArgs
	switch r.Kind {
	case CAA:
		recordArgs = &cloudflare.RecordArgs{
			ZoneId: r.getZone(),
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
			ZoneId:   r.getZone(),
			Name:     pulumi.String(r.Name),
			Type:     pulumi.String(strings.ToUpper(string(r.Kind))),
			Ttl:      pulumi.Int(r.Ttl),
			Priority: pulumi.Int(r.Priority),
			Value:    pulumi.String(r.Value),
		}
	}
	r.CFRecord, err = cloudflare.NewRecord(ctx, r.getName(), recordArgs, pulumi.DependsOn([]pulumi.Resource{r.Zone.CFZone}))
	return err
}
