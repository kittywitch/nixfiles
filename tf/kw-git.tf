resource "cloudflare_record" "git" {
  name    = "git"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}
