resource "cloudflare_record" "monica" {
  name    = "monica"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "yukari.gensokyo.zone"
  zone_id = local.zone_ids.gensokyo
}