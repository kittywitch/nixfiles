resource "cloudflare_record" "terraform_managed_resource_4078b739fc60f37d90a25448e08b6616" {
	name    = "yukari"
	proxied = false
	ttl     = 3600
	type    = "A"
	value   = hcloud_server.yukari.ipv4_address
	zone_id = local.zone_ids.gensokyo
}

resource "cloudflare_record" "terraform_managed_resource_1206b053e895e4f6a9d1b3b4856db871" {
	name    = "yukari"
	proxied = false
	ttl     = 3600
	type    = "AAAA"
	value   = hcloud_server.yukari.ipv6_address
	zone_id = local.zone_ids.gensokyo
}