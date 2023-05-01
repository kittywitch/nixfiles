resource "cloudflare_record" "yukari_v4" {
	name    = "yukari"
	proxied = false
	ttl     = 3600
	type    = "A"
	value   = hcloud_server.yukari.ipv4_address
	zone_id = local.zone_ids.gensokyo
}

resource "cloudflare_record" "yukari_v6" {
	name    = "yukari"
	proxied = false
	ttl     = 3600
	type    = "AAAA"
	value   = hcloud_server.yukari.ipv6_address
	zone_id = local.zone_ids.gensokyo
}