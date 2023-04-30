variable "cloudflare_apartment_tunnel" {
    sensitive = true
}

resource "cloudflare_tunnel" "gensokyo_apartment_tunnel" {
  account_id = local.account_id
  name       = "Apartment"
  secret     = var.cloudflare_apartment_tunnel
}

resource "cloudflare_record" "gensokyo_root" {
  name    = local.zones.gensokyo
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = cloudflare_tunnel.gensokyo_apartment_tunnel.cname
  zone_id = local.zone_ids.gensokyo
}

resource "cloudflare_record" "gensokyo_home" {
  name    = "home"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = cloudflare_tunnel.gensokyo_apartment_tunnel.cname
  zone_id = local.zone_ids.gensokyo
}

resource "cloudflare_record" "gensokyo_id" {
  name    = "id"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = cloudflare_tunnel.gensokyo_apartment_tunnel.cname
  zone_id = local.zone_ids.gensokyo
}

resource "cloudflare_record" "gensokyo_login" {
  name    = "login"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = cloudflare_tunnel.gensokyo_apartment_tunnel.cname
  zone_id = local.zone_ids.gensokyo
}

resource "cloudflare_record" "gensokyo_warez" {
  name    = "warez"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = cloudflare_tunnel.gensokyo_apartment_tunnel.cname
  zone_id = local.zone_ids.gensokyo
}

resource "cloudflare_record" "gensokyo_z2m" {
  name    = "z2m"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = cloudflare_tunnel.gensokyo_apartment_tunnel.cname
  zone_id = local.zone_ids.gensokyo
}

