resource "cloudflare_record" "rss" {
  name    = "rss"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "yukari.gensokyo.zone"
  zone_id = local.zone_ids.kittywitch
}