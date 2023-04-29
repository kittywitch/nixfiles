resource "cloudflare_record" "terraform_managed_resource_328ec45cd6cfa9fb4d32c4dfe7b3d5e2" {
  name    = "inskip.me"
  proxied = false
  ttl     = 3600
  type    = "CAA"
  zone_id = "635716e7dd314fd5ec52f9434bd4527d"
  data {
    flags = 0
    tag   = "iodef"
    value = "mailto:acme@inskip.me"
  }
}

resource "cloudflare_record" "terraform_managed_resource_d1cfb156d1cccd583dedf9571ec20c8d" {
  name    = "inskip.me"
  proxied = false
  ttl     = 3600
  type    = "CAA"
  zone_id = "635716e7dd314fd5ec52f9434bd4527d"
  data {
    flags = 0
    tag   = "issue"
    value = "letsencrypt.org"
  }
}

resource "cloudflare_record" "terraform_managed_resource_9f1178aab1a0c152b0870a9bc10cae6b" {
  name    = "inskip.me"
  proxied = false
  ttl     = 3600
  type    = "CAA"
  zone_id = "635716e7dd314fd5ec52f9434bd4527d"
  data {
    flags = 0
    tag   = "issuewild"
    value = ";"
  }
}

resource "cloudflare_record" "terraform_managed_resource_e3d130cd7057def47a2365656bdb952e" {
  name    = "inskip.me"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "inskip-root.pages.dev"
  zone_id = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "terraform_managed_resource_2490d32a4fb7400c07503d24675955cb" {
  name     = "inskip.me"
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt3.aspmx.l.google.com"
  zone_id  = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "terraform_managed_resource_9f87bf476adbe001d227c32693e08ba1" {
  name     = "inskip.me"
  priority = 1
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "aspmx.l.google.com"
  zone_id  = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "terraform_managed_resource_ec7ec3c413def145dafc6530f630f647" {
  name     = "inskip.me"
  priority = 10
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt4.aspmx.l.google.com"
  zone_id  = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "terraform_managed_resource_80559b7ee777c1e94aa4be4c3c18e6c2" {
  name     = "inskip.me"
  priority = 5
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
  zone_id  = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "terraform_managed_resource_80b48ce49c59ee6380fa4eb2ccc9fa8a" {
  name     = "inskip.me"
  priority = 5
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
  zone_id  = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "terraform_managed_resource_f9a42e77eeb06fb20c0fcb01e2608601" {
  name     = "inskip.me"
  priority = 15
  proxied  = false
  ttl      = 3600
  type     = "MX"
  value    = "6uyykkzhqi4zgogxiicbuamoqrxajwo5werga4byh77b2iyx3wma.mx-verification.google.com"
  zone_id  = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "terraform_managed_resource_cf503ffe8c92e5195315b8b7d0028903" {
  name    = "google._domainkey"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkxag/EmXQ89XQmLrBDPpPtZ7EtEJT0hgvWf/+AFiOfBOm902tq9NbTTvRJ2dLeBLPaV+hNvq2Alc7UfkKUDlLTWQjeuiC6aOnRKQQg3LZ2W25U3AlIj0jd2IPiUhg9JGV4c66XiqQ5ylTBniShfUUyeAXxbPhYFBCkBg62LZcO/tFpFsdKWtZzLjgac5vTJID+M4F8duHpkA/ZCNNUEmtt7RNQB/LLI1Gr5yR4GdQl9z7NmwtOTo9pghbZuvljr8phYjdDrwZeFTMKQnvR1l2Eh/dZ8I0C4nP5Bk4QEfmLq666P1HzOxwT6iCU6Tc+P/pkWbrx0HJh39E1aKGyLJMQIDAQAB"
  zone_id = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "terraform_managed_resource_f5b4da4e6ffacca4bf188f861543f1d2" {
  name    = "inskip.me"
  proxied = false
  ttl     = 3600
  type    = "TXT"
  value   = "v=spf1 include:_spf.google.com -all"
  zone_id = "635716e7dd314fd5ec52f9434bd4527d"
}