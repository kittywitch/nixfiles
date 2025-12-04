resource "cloudflare_record" "gmail_mx_1_aspmx" {
  count    = var.enable ? 1 : 0
  name     = var.zone_name
  priority = 1
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "aspmx.l.google.com"
  zone_id  = var.zone_id
}

resource "cloudflare_record" "gmail_mx_5_alt1" {
  count    = var.enable ? 1 : 0
  name     = var.zone_name
  priority = 5
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
  zone_id  = var.zone_id
}

resource "cloudflare_record" "gmail_mx_5_alt2" {
  count    = var.enable ? 1 : 0
  name     = var.zone_name
  priority = 5
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
  zone_id  = var.zone_id
}

resource "cloudflare_record" "gmail_mx_10_alt3" {
  count    = var.enable ? 1 : 0
  name     = var.zone_name
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt3.aspmx.l.google.com"
  zone_id  = var.zone_id
}
resource "cloudflare_record" "gmail_mx_10_alt4" {
  count    = var.enable ? 1 : 0
  name     = var.zone_name
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt4.aspmx.l.google.com"
  zone_id  = var.zone_id
}

resource "cloudflare_record" "gmail_dkim" {
  count   = var.enable ? 1 : 0
  name    = "google._domainkey"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = var.dkim
  zone_id = var.zone_id
}

resource "cloudflare_record" "gmail_spf" {
  count   = var.enable ? 1 : 0
  name    = var.zone_name
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=spf1 include:_spf.google.com -all"
  zone_id = var.zone_id
}
