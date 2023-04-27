resource "cloudflare_record" "terraform_managed_resource_81084240cdb26c251ea645dc4750f336" {
  name    = "daiyousei"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = "132.145.26.5"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_a98f9a4f1d37552e77144fbb8d649c48" {
  name    = "marisa"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = "104.244.72.5"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_fbb99ac0153533f40ae55ed2c6a645d4" {
  name    = "daiyousei"
  proxied = false
  ttl     = 3600
  type    = "AAAA"
  value   = "2603:c020:c004:6f00::6"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_4d1ed3a6dd2bce46616cbc55356fa2e7" {
  name    = "marisa"
  proxied = false
  ttl     = 3600
  type    = "AAAA"
  value   = "2605:6400:30:eed1:6cf7:bbfc:b4e:15c0"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_f321912fb8af212f7e5576c1e1553456" {
  name    = "auth"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.kittywit.ch"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_89158423a9c03fc7ff6fecd8cbb04e4d" {
  name    = "files"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.kittywit.ch"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_1125359cc05a16a0950fd259de437c86" {
  name    = "irc"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.kittywit.ch"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_92ffaf7e0cfd9bb265a01448160abbf5" {
  name    = "kittywit.ch"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "yukari.gensokyo.zone"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_95d39eb707041e694c6b7f03cbae6b11" {
  name    = "vault"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "yukari.gensokyo.zone"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_f9c5cd6756f6f95edeece5ea0fa6e9d3" {
  name    = "znc"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "daiyousei.kittywit.ch"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_7d001e7fbe6114cb801b95e3f9ae3d4a" {
  name     = "kittywit.ch"
  priority = 5
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
  zone_id  = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_5b9ed0221972375abcccc03607c6c1c9" {
  name     = "kittywit.ch"
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt3.aspmx.l.google.com"
  zone_id  = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_272d367473f25350a7ad968036bdbbea" {
  name     = "kittywit.ch"
  priority = 1
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "aspmx.l.google.com"
  zone_id  = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_bf71e5b8e9b45e96009c938b32726c43" {
  name     = "kittywit.ch"
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt4.aspmx.l.google.com"
  zone_id  = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_cbb0021fd35fa0c5e5e2246a42b2eb3b" {
  name     = "kittywit.ch"
  priority = 5
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
  zone_id  = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_046314ee49d8507b408ed278b2037c77" {
  name    = "_atproto"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "did=did:plc:4rkjqsakfq3chmepfcd3al6e"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_d891520f86c4be0bf1c5787915ff5456" {
  name    = "kittywit.ch"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=spf1 include:_spf.google.com -all"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

resource "cloudflare_record" "terraform_managed_resource_908b522e823e83779b423b6b95cc17fa" {
  name    = "kittywit.ch"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "google-site-verification=aeWWfadYbcHt_XTD8aM-MpX0VIDDt0AZIba4QDNhs0k"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}

