resource "cloudflare_record" "ran_v4" {
	name    = "ran"
	proxied = false
	ttl     = 3600
	type    = "A"
	value   = hcloud_server.ran.ipv4_address
	zone_id = local.zone_ids.gensokyo
}

resource "cloudflare_record" "ran_v6" {
	name    = "ran"
	proxied = false
	ttl     = 3600
	type    = "AAAA"
	value   = hcloud_server.ran.ipv6_address
	zone_id = local.zone_ids.gensokyo
}