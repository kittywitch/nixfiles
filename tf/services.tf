resource "cloudflare_record" "rinnosuke_v4" {
  name    = "rinnosuke"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = "154.12.117.50"
  zone_id = local.zone_ids.inskip
}

resource "cloudflare_record" "rinnosuke_v6" {
  name    = "rinnosuke"
  proxied = false
  ttl     = 3600
  type    = "AAAA"
  value   = "2602:ffd5:1:301::1a"
  zone_id = local.zone_ids.inskip
}

resource "cloudflare_record" "bluesky_did" {
  name    = "_atproto"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "did=did:plc:4rkjqsakfq3chmepfcd3al6e"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "git" {
  name    = "git"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "irc" {
  name    = "irc"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "rss" {
  name    = "rss"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "ntfy" {
  name    = "ntfy"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "kuma" {
  name    = "kuma"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "mei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "stream" {
  name    = "stream"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "music" {
  name    = "music"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.inskip.me"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "dork_mail_mx" {
  name     = "@"
  proxied  = false
  ttl      = 3600
  type     = "MX"
  priority = 10
  value    = "rinnosuke.inskip.me"
  zone_id  = local.zone_ids.dork
}

resource "cloudflare_record" "dork_mail_spf" {
  name    = "@"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=spf1 a:rinnosuke.inskip.me -all"
  zone_id = local.zone_ids.dork
}


