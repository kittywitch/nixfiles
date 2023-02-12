package iac

import (
	"fmt"
	"github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
	"github.com/pulumi/pulumi-cloudinit/sdk/go/cloudinit"
	"github.com/pulumi/pulumi-hcloud/sdk/go/hcloud"
	"github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"strconv"
)

type Machine struct {
	Hostname      string
	Network       *hcloud.Network
	NetworkSubnet *hcloud.NetworkSubnet
	NetworkID     pulumi.IntOutput
	TailnetKey    *tailscale.TailnetKey
	CloudInit     *cloudinit.Config
	IPv4          *hcloud.PrimaryIp
	IPv6          *hcloud.PrimaryIp
	RDNSv4        *hcloud.Rdns
	RDNSv6        *hcloud.Rdns
	Server        *hcloud.Server
	Recordv4      DNSRecord
	Recordv6      DNSRecord
}

func (m *Machine) Handle(ctx *pulumi.Context, name string) (err error) {
	m.Hostname = name

	m.Network, err = hcloud.NewNetwork(ctx, "network", &hcloud.NetworkArgs{
		IpRange: pulumi.String("10.0.0.0/16"),
	})
	if err != nil {
		return err
	}

	m.NetworkID = m.Network.ID().ApplyT(func(content pulumi.ID) (content_ int, err error) {
		return strconv.Atoi(string(content))
	}).(pulumi.IntOutput)

	m.NetworkSubnet, err = hcloud.NewNetworkSubnet(ctx, "network-subnet", &hcloud.NetworkSubnetArgs{
		NetworkId:   m.NetworkID,
		Type:        pulumi.String("cloud"),
		NetworkZone: pulumi.String("us-west"),
		IpRange:     pulumi.String("10.0.1.0/24"),
	})
	if err != nil {
		return err
	}
	m.TailnetKey, err = tailscale.NewTailnetKey(ctx, "tailscaleKey", &tailscale.TailnetKeyArgs{
		Ephemeral:     pulumi.Bool(false),
		Preauthorized: pulumi.Bool(true),
		Reusable:      pulumi.Bool(true),
	})
	if err != nil {
		return err
	}

	m.CloudInit, err = cloudinit.NewConfig(ctx, "ran", &cloudinit.ConfigArgs{
		Gzip:         pulumi.Bool(false),
		Base64Encode: pulumi.Bool(false),
		Parts: cloudinit.ConfigPartArray{
			&cloudinit.ConfigPartArgs{
				Content: pulumi.Sprintf(`#cloud-config
write_files:
- path: /etc/tailscale/authkey
  permissions: '0600'
  content: "%s"
- path: /etc/nixos/katdefaults.nix
  permissions: '0644'
  content: |
    { pkgs, ... }:
    {
      services.tailscale.enable = true;

      systemd.services.tailscale-autoconnect = {
        description = "Automatic connection to Tailscale";
        after = [ "network-pre.target" "tailscale.service" ];
        wants = [ "network-pre.target" "tailscale.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        path = with pkgs; [ jq tailscale ];
        script = ''
          sleep 2
          status="$(tailscale status -json | jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi
          tailscale up --authkey $(cat /etc/tailscale/authkey) --ssh
        '';
      };
    }
runcmd:
- sed -i 's:#.*$::g' /root/.ssh/authorized_keys
- curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIXOS_IMPORT=./katdefaults.nix NIX_CHANNEL=nixos-unstable bash 2>&1 | tee /tmp/infect.log
- nixos-generate-config --dir ./
`, m.TailnetKey.Key),
				ContentType: pulumi.String("text/x-shellscript"),
				Filename:    pulumi.String("nixos-infect"),
			},
		},
	})
	if err != nil {
		return err
	}

	m.IPv4, err = hcloud.NewPrimaryIp(ctx, "ran-v4", &hcloud.PrimaryIpArgs{
		Datacenter:   pulumi.String("hil-dc1"),
		Type:         pulumi.String("ipv4"),
		AssigneeType: pulumi.String("server"),
		AutoDelete:   pulumi.Bool(true),
		Labels: pulumi.Map{
			"host": pulumi.Any("ran"),
		},
	})
	if err != nil {
		return err
	}

	m.IPv6, err = hcloud.NewPrimaryIp(ctx, "ran-v6", &hcloud.PrimaryIpArgs{
		Datacenter:   pulumi.String("hil-dc1"),
		Type:         pulumi.String("ipv6"),
		AssigneeType: pulumi.String("server"),
		AutoDelete:   pulumi.Bool(true),
		Labels: pulumi.Map{
			"host": pulumi.Any("ran"),
		},
	})
	if err != nil {
		return err
	}

	m.Server, err = hcloud.NewServer(ctx, m.Hostname, &hcloud.ServerArgs{
		Name:       pulumi.String(m.Hostname),
		ServerType: pulumi.String("cpx21"),
		Image:      pulumi.String("ubuntu-22.04"),
		Datacenter: pulumi.String("hil-dc1"),
		UserData:   m.CloudInit.Rendered,
		PublicNets: hcloud.ServerPublicNetArray{
			&hcloud.ServerPublicNetArgs{
				Ipv4Enabled: pulumi.Bool(true),
				Ipv4: m.IPv4.ID().ApplyT(func(content pulumi.ID) (content_ int, err error) {
					return strconv.Atoi(string(content))
				}).(pulumi.IntOutput),
				Ipv6Enabled: pulumi.Bool(true),
				Ipv6: m.IPv6.ID().ApplyT(func(content pulumi.ID) (content_ int, err error) {
					return strconv.Atoi(string(content))
				}).(pulumi.IntOutput),
			},
		},
		Networks: hcloud.ServerNetworkTypeArray{
			&hcloud.ServerNetworkTypeArgs{
				NetworkId: m.NetworkID,
				Ip:        pulumi.String("10.0.1.5"),
				AliasIps: pulumi.StringArray{
					pulumi.String("10.0.1.6"),
					pulumi.String("10.0.1.7"),
				},
			},
		},
	}, pulumi.DependsOn([]pulumi.Resource{
		m.NetworkSubnet,
	}))
	if err != nil {
		return err
	}
	m.RDNSv4, err = hcloud.NewRdns(ctx, fmt.Sprintf("%s-v4", m.Hostname), &hcloud.RdnsArgs{
		ServerId: m.Server.ID().ApplyT(func(content pulumi.ID) (content_ int, err error) {
			return strconv.Atoi(string(content))
		}).(pulumi.IntOutput),
		IpAddress: m.Server.Ipv4Address,
		DnsPtr:    pulumi.String("ran.gensokyo.zone"),
	})
	m.RDNSv6, err = hcloud.NewRdns(ctx, fmt.Sprintf("%s-v6", m.Hostname), &hcloud.RdnsArgs{
		ServerId: m.Server.ID().ApplyT(func(content pulumi.ID) (content_ int, err error) {
			return strconv.Atoi(string(content))
		}).(pulumi.IntOutput),
		IpAddress: m.Server.Ipv6Address,
		DnsPtr:    pulumi.String("ran.gensokyo.zone"),
	})

	zoneName := "gensokyo.zone"

	gensokyo, err := cloudflare.LookupZone(ctx, &cloudflare.LookupZoneArgs{
		Name: &zoneName,
	})
	if err != nil {
		return err
	}

	m.Recordv4 = DNSRecord{
		Higher:   String,
		Name:     m.Hostname,
		Kind:     A,
		RawValue: m.Server.Ipv4Address,
		Ttl:      3600,
	}
	m.Recordv4.handleValue(ctx, gensokyo)

	m.Recordv6 = DNSRecord{
		Higher:   String,
		Name:     m.Hostname,
		Kind:     AAAA,
		RawValue: m.Server.Ipv6Address,
		Ttl:      3600,
	}
	m.Recordv6.handleValue(ctx, gensokyo)

	return err
}
