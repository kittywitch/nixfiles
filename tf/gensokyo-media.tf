variable "cloudflare_mediabox_tunnel" {
    sensitive = true
}

locals {
  subdomains = [
    "plex",
    "sonarr",
    "radarr",
    "jackett",
    "tautulli",
    "bazarr",
    "ombi",
    "deluge",
  ]
}

resource "cloudflare_tunnel" "gensokyo_mediabox_tunnel" {
  account_id = local.account_id
  name       = "Mediabox"
  secret     = var.cloudflare_mediabox_tunnel
  config_src = "local"
}

resource "cloudflare_record" "gensokyo_mediabox_records" {
  for_each = toset(local.subdomains)
  name    = each.value
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = cloudflare_tunnel.gensokyo_mediabox_tunnel.cname
  zone_id = local.zone_ids.gensokyo
}