resource "cloudflare_record" "rss" {
  name    = "rss"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}
