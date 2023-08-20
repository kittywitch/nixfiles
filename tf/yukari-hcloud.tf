resource "hcloud_primary_ip" "ipv4" {
	auto_delete = false
	name = "yukari-v4-aef50a7"
	datacenter = "hil-dc1"
	type = "ipv4"
	assignee_type = "server"
}


resource "hcloud_primary_ip" "ipv6" {
	auto_delete = false
	name = "yukari-v6-66a4b55"
	datacenter = "hil-dc1"
	type = "ipv6"
	assignee_type = "server"
}
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
            server_type,
            user_data,
            public_net
        ]
    }
}

resource "hcloud_rdns" "yukari-v4" {
    server_id  = hcloud_server.yukari.id
    ip_address = hcloud_server.yukari.ipv4_address
    dns_ptr    = "yukari.gensokyo.zone"
}

resource "hcloud_rdns" "yukari-v6" {
    server_id  = hcloud_server.yukari.id
    ip_address = hcloud_server.yukari.ipv6_address
    dns_ptr    = "yukari.gensokyo.zone"
}