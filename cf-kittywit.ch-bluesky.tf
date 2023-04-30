resource "cloudflare_record" "bluesky_did" {
  name    = "_atproto"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "did=did:plc:4rkjqsakfq3chmepfcd3al6e"
  zone_id = local.zone_ids.kittywitch
}