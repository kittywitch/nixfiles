resource "cloudflare_record" "monica" {
  name    = "monica"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "yukari.gensokyo.zone"
  zone_id = local.zone_ids.kittywitch
}