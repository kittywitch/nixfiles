resource "cloudflare_record" "terraform_managed_resource_be014cdcf644d74baaa31a75515e48e1" {
  name     = "dork.dev"
  priority = 1
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "aspmx.l.google.com"
  zone_id  = "ef175eefc568696fb70bb591cbf0f7de"
}

resource "cloudflare_record" "terraform_managed_resource_11e7954d90a54554505d70927b438377" {
  name     = "dork.dev"
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt3.aspmx.l.google.com"
  zone_id  = "ef175eefc568696fb70bb591cbf0f7de"
}

resource "cloudflare_record" "terraform_managed_resource_3a795ae0bb3e81e2f7fe3327e19ce55b" {
  name     = "dork.dev"
  priority = 5
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
  zone_id  = "ef175eefc568696fb70bb591cbf0f7de"
}

resource "cloudflare_record" "terraform_managed_resource_b3c56b9d9b184bd0c875f419ee25dd52" {
  name     = "dork.dev"
  priority = 5
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
  zone_id  = "ef175eefc568696fb70bb591cbf0f7de"
}

resource "cloudflare_record" "terraform_managed_resource_28a4d78a49b59ae2471c888f13cec013" {
  name     = "dork.dev"
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt4.aspmx.l.google.com"
  zone_id  = "ef175eefc568696fb70bb591cbf0f7de"
}

resource "cloudflare_record" "terraform_managed_resource_c344b0387d935ffc9ed65c27d03ff970" {
  name    = "dork.dev"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=spf1 include:_spf.google.com -all"
  zone_id = "ef175eefc568696fb70bb591cbf0f7de"
}

resource "cloudflare_record" "terraform_managed_resource_f8299041068f945fc8a780f6a151588f" {
  name    = "dork.dev"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "google-site-verification=EmWW9eKOr4b4e624hTL-bvzJseiARrvQqLhKGn7vAek"
  zone_id = "ef175eefc568696fb70bb591cbf0f7de"
}

resource "cloudflare_record" "terraform_managed_resource_7e0f915b0085c329c8d0c0829e3b210f" {
  name    = "google._domainkey"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAziwoHJbM1rmeUiIXOgg0cujTL5BFW9PQOksUhKza1XpDP2rpzTlQr21NFYMJMc08xiE3AbvScMTX0jX3gc7+XoIYLD1VigRRvkyTubVfRmatqj+Pk41Fle1jWXHv5vNIYjjcsUTrpnrXYKoYrz34TtsmYHnu0G9MgmmcQGmbRU+WY+1R/ukhavlgXasfEW6r4tjLgVxQnser1Zjr80AUcu23od/+o+m6C9rDGMMnv6NIc2DOT7Ei6o60458f2Iwcpg38te22dy46A8AeGynbpB9+jF33Se0m22eKk5qZN5mfju/wxWMsl7ifCY/eqLZXRxJaEd5bMI8px5KvZp1TWwIDAQAB"
  zone_id = "ef175eefc568696fb70bb591cbf0f7de"
}

