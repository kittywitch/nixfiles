package iac

import (
    "fmt"
    "github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
    "strconv"
    "github.com/pulumi/pulumi-cloudinit/sdk/go/cloudinit"
    "github.com/pulumi/pulumi-hcloud/sdk/go/hcloud"
    "github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
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


func IDToInt(id pulumi.IDOutput) (pulumi.IntOutput) {
    var conversionCallback = func(val string) (int, error) {
        return strconv.Atoi(val)
    }

    return id.ApplyT(conversionCallback).(pulumi.IntOutput);
}

// TODO: make the hcloud server process occur in a series of nested ApplyTs, to allow the conversion without actually causing issues in dependency resolution since the directionality flows from the network to the RDNS.
func (m *Machine) Handle(ctx *pulumi.Context, name string) (err error) {
    m.Hostname = name

    // when creating, comment out the rest of this file and deploy with this first, to create the network in the first place.
    m.Network, err = hcloud.NewNetwork(ctx, "network", &hcloud.NetworkArgs{
        IpRange: pulumi.String("10.0.0.0/16"),
    })
    if err != nil {
        return err
    }

    
    m.NetworkID = IDToInt(m.Network.ID())

    m.NetworkSubnet, err = hcloud.NewNetworkSubnet(ctx, fmt.Sprintf("%s-primarySubnet", m.Hostname), &hcloud.NetworkSubnetArgs{
        NetworkId:   m.NetworkID,
        Type:        pulumi.String("cloud"),
        NetworkZone: pulumi.String("us-west"),
        IpRange:     pulumi.String("10.0.1.0/24"),
    }, pulumi.DependsOn([]pulumi.Resource{
        m.Network,
    }))
    if err != nil {
        return err
    }
    m.TailnetKey, err = tailscale.NewTailnetKey(ctx, fmt.Sprintf("%s-tailscaleKey", m.Hostname), &tailscale.TailnetKeyArgs{
        Ephemeral:     pulumi.Bool(false),
        Preauthorized: pulumi.Bool(true),
        Reusable:      pulumi.Bool(true),
    })
    if err != nil {
        return err
    }

    m.CloudInit, err = cloudinit.NewConfig(ctx, fmt.Sprintf("%s", m.Hostname), &cloudinit.ConfigArgs{
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
    let
        katKeys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPsu3vNsvBb/G+wALpstD/DnoRZ3fipAs00jtl8rzDuv96RlS7AJr4aNvG6Pt2D9SYn2wVLaiw+76mz2gOycH9/N+VCvL4/0MN9uqj+7XIcxNRo0gHVOblmi2bOXcmGKh3eRwHj1xyDwRxo9WIuBEP2bPpDPz75OXRtEdlTgvky7siSguQxJu03cb0p9hNAYhUoohNXyWW2CjDCLUQVE1+QRVUzsKq3KkPy0cHYgmZC1gRSMQyKpMt72L5tayLz3Tp/zrshucc+QO5IJeZdqMxsNAcvALsysT1J5EqxZoYH9VpWLRhSgVD6Nvn853pycJAlXQxgOCpSD3/v/JbgUe5NE+ci0o7NMy5IiHUv2gQMRIEhwBHlRGwokUPL9upx0lsjaEiPya5xQqqDKRom87xytM778ANS5CuMdQMWg9qVbpHZUHMjA0QmNkjPgq71pUDXHk5L4mZuS8wVjyjnvlw68yIJuHEc8P7QiLcjvRHFS2L9Ck8NRmPDTQXlQi9kk6LmMyu6fdevR/kZL21b+xO1e2DMyxBbNDTot8luppiiL8adgUDMwptpIne7JCWB1o9NFCbXUVgwuCCYBif6pOGSc6bGo1JTAKMflRlcy6Mi3t5H0mR2lj/sCSTWwTlP5FM4aPIq08NvW6PeuK1bFJY9fIgTwVsUnbAKOhmsMt62w== cardno:12_078_454"];
    in {
      services.tailscale.enable = true;
      users.users.root.openssh.authorizedKeys.keys = katKeys;

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

    m.IPv4, err = hcloud.NewPrimaryIp(ctx, fmt.Sprintf("%s-v4", m.Hostname), &hcloud.PrimaryIpArgs{
        Datacenter:   pulumi.String("hil-dc1"),
        Type:         pulumi.String("ipv4"),
        AssigneeType: pulumi.String("server"),
        AutoDelete:   pulumi.Bool(true),
        Labels: pulumi.Map{
            "host": pulumi.Any("ran"),
        },
    }, pulumi.DependsOn([]pulumi.Resource{
        m.Network,
        m.NetworkSubnet,
    }))
    if err != nil {
        return err
    }

    m.IPv6, err = hcloud.NewPrimaryIp(ctx, fmt.Sprintf("%s-v6", m.Hostname), &hcloud.PrimaryIpArgs{
        Datacenter:   pulumi.String("hil-dc1"),
        Type:         pulumi.String("ipv6"),
        AssigneeType: pulumi.String("server"),
        AutoDelete:   pulumi.Bool(true),
        Labels: pulumi.Map{
            "host": pulumi.Any("ran"),
        },
    }, pulumi.DependsOn([]pulumi.Resource{
        m.Network,
        m.NetworkSubnet,
    }))
    if err != nil {
        return err
    }

    m.Server, err = hcloud.NewServer(ctx, m.Hostname, &hcloud.ServerArgs{
        Name:       pulumi.String(m.Hostname),
        ServerType: pulumi.String("cpx21"),
        Image:      pulumi.String("67794396"),
        Datacenter: pulumi.String("hil-dc1"),
        UserData:   m.CloudInit.Rendered,
        PublicNets: hcloud.ServerPublicNetArray{
            &hcloud.ServerPublicNetArgs{
                Ipv4Enabled: pulumi.Bool(true),
                Ipv4: IDToInt(m.IPv4.ID()),
                Ipv6Enabled: pulumi.Bool(true),
                Ipv6: IDToInt(m.IPv6.ID()),
            },
        },
        Networks: hcloud.ServerNetworkTypeArray{
            &hcloud.ServerNetworkTypeArgs{
                NetworkId:   m.NetworkID,
                Ip:        pulumi.String("10.0.1.5"),
                AliasIps: pulumi.StringArray{
                    pulumi.String("10.0.1.6"),
                    pulumi.String("10.0.1.7"),
                },
            },
        },
    }, pulumi.IgnoreChanges([]string{"image"}), pulumi.DependsOn([]pulumi.Resource{
        m.NetworkSubnet,
        m.IPv4,
        m.IPv6,
    }))
    if err != nil {
        return err
    }
    
    m.RDNSv4, err = hcloud.NewRdns(ctx, fmt.Sprintf("%s-v4", m.Hostname), &hcloud.RdnsArgs{
        ServerId: IDToInt(m.Server.ID()),
        IpAddress: m.Server.Ipv4Address,
        DnsPtr:    pulumi.String(fmt.Sprintf("%s.gensokyo.zone", m.Hostname)),
    }, pulumi.DependsOn([]pulumi.Resource{
        m.Server,
    }))
    m.RDNSv6, err = hcloud.NewRdns(ctx, fmt.Sprintf("%s-v6", m.Hostname), &hcloud.RdnsArgs{
        ServerId: IDToInt(m.Server.ID()),
        IpAddress: m.Server.Ipv6Address,
        DnsPtr:    pulumi.String(fmt.Sprintf("%s.gensokyo.zone", m.Hostname)),
    }, pulumi.DependsOn([]pulumi.Resource{
        m.Server,
    }))

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
