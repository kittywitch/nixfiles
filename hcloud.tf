variable "hcloud_token" {
    sensitive = true
}

provider "hcloud" {
    token = var.hcloud_token
}

variable "tailscale_api_key" {
    sensitive = true
}

variable "tailnet" {
    sensitive = false
}

provider "tailscale" {
    api_key = var.tailscale_api_key
    tailnet = var.tailnet
}


/*
resource "hcloud_server" "server"
    for_each = servers
    name = each.key
    server_type = each.value.server_type
*/

/*
	// when creating, comment out the rest of this file and deploy with this first, to create the network in the first place.
	m.Network, err = hcloud.NewNetwork(ctx, "network", &hcloud.NetworkArgs{
		IpRange: pulumi.String("10.0.0.0/16"),
	})
	if err != nil {
		return err
	}

	m.NetworkID = IDToInt(m.Network.ID())
*/

// Network

resource "hcloud_network" "network" {
  name     = "network-17a07f9"
  ip_range = "10.0.0.0/16"
}

/*
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
*/

resource "hcloud_network_subnet" "subnet" {
    network_id = hcloud_network.network.id 
    type = "cloud"
    network_zone = "us-west"
    ip_range = "10.0.1.0/24"
}

/*
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
*/

resource "hcloud_primary_ip" "ipv4" {
	auto_delete = false
	name = "yukari-v4-aef50a7"
	datacenter = "hil-dc1"
	type = "ipv4"
	assignee_type = "server"
}

/*
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
*/

resource "hcloud_primary_ip" "ipv6" {
	auto_delete = false
	name = "yukari-v6-66a4b55"
	datacenter = "hil-dc1"
	type = "ipv6"
	assignee_type = "server"
}

/*
	m.Server, err = hcloud.NewServer(ctx, m.Hostname, &hcloud.ServerArgs{
		Name:       pulumi.String(m.Hostname),
		ServerType: pulumi.String("cpx21"),
		Image:      pulumi.String("67794396"),
		Datacenter: pulumi.String("hil-dc1"),
		UserData:   m.CloudInit.Rendered,
		PublicNets: hcloud.ServerPublicNetArray{
			&hcloud.ServerPublicNetArgs{
				Ipv4Enabled: pulumi.Bool(true),
				Ipv4:        IDToInt(m.IPv4.ID()),
				Ipv6Enabled: pulumi.Bool(true),
				Ipv6:        IDToInt(m.IPv6.ID()),
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
	}, pulumi.IgnoreChanges([]string{"image"}), pulumi.DependsOn([]pulumi.Resource{
		m.NetworkSubnet,
		m.IPv4,
		m.IPv6,
	}))
	if err != nil {
		return err
	}
	*/

	resource "hcloud_server" "yukari" {
		name = "yukari"
		server_type = "cpx21"
		keep_disk = true
		allow_deprecated_images = false
		image = "ubuntu-22.04"
		datacenter = "hil-dc1"
		public_net {
			ipv4_enabled = true
			ipv4 = hcloud_primary_ip.ipv4.id
			ipv6_enabled = true
			ipv6 = hcloud_primary_ip.ipv6.id
		}
		
		lifecycle {
			ignore_changes = [
				user_data,
				public_net
			]
		}
	}

	/*
	m.RDNSv4, err = hcloud.NewRdns(ctx, fmt.Sprintf("%s-v4", m.Hostname), &hcloud.RdnsArgs{
		ServerId:  IDToInt(m.Server.ID()),
		IpAddress: m.Server.Ipv4Address,
		DnsPtr:    pulumi.String(fmt.Sprintf("%s.gensokyo.zone", m.Hostname)),
	}, pulumi.DependsOn([]pulumi.Resource{
		m.Server,
	}))
	if err != nil {
		return err
	}
	*/

	resource "hcloud_rdns" "yukari-v4" {
		server_id  = hcloud_server.yukari.id
		ip_address = hcloud_server.yukari.ipv4_address
		dns_ptr    = "yukari.gensokyo.zone"
	}

	/*
	m.RDNSv6, err = hcloud.NewRdns(ctx, fmt.Sprintf("%s-v6", m.Hostname), &hcloud.RdnsArgs{
		ServerId:  IDToInt(m.Server.ID()),
		IpAddress: m.Server.Ipv6Address,
		DnsPtr:    pulumi.String(fmt.Sprintf("%s.gensokyo.zone", m.Hostname)),
	}, pulumi.DependsOn([]pulumi.Resource{
		m.Server,
	}))
	if err != nil {
		return err
	}
	*/

	resource "hcloud_rdns" "yukari-v6" {
		server_id  = hcloud_server.yukari.id
		ip_address = hcloud_server.yukari.ipv6_address
		dns_ptr    = "yukari.gensokyo.zone"
	}

	/*
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
*/