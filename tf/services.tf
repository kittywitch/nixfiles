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

resource "cloudflare_record" "webmail" {
  name    = "webmail"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "rinnosuke.inskip.me"
  zone_id = local.zone_ids.dork
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

resource "cloudflare_record" "inskip_mail_mx" {
  name     = "@"
  proxied  = false
  ttl      = 3600
  type     = "MX"
  priority = 10
  value    = "rinnosuke.inskip.me"
  zone_id  = local.zone_ids.inskip
}

resource "cloudflare_record" "kittywitch_mail_mx" {
  name     = "@"
  proxied  = false
  ttl      = 3600
  type     = "MX"
  priority = 10
  value    = "rinnosuke.inskip.me"
  zone_id  = local.zone_ids.kittywitch
}

resource "cloudflare_record" "dork_mail_spf" {
  name    = "@"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=spf1 a:rinnosuke.inskip.me -all"
  zone_id = local.zone_ids.dork
}

resource "cloudflare_record" "inskip_mail_spf" {
  name    = "@"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=spf1 a:rinnosuke.inskip.me -all"
  zone_id = local.zone_ids.inskip
}

resource "cloudflare_record" "kittywitch_mail_spf" {
  name    = "@"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=spf1 a:rinnosuke.inskip.me -all"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "dork_mail_dkim" {
  name    = "mail._domainkey"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=DKIM1; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsfSxe5JNdrSyHoPuESnOles7KxP5NtHD60YZ7SXLANNkEb8/tSHmg4nGqLhqKrA7+gcrurjowibDYs4hAM/ozkMNch53n2ZVKRl1ExMSRAPlGl5ZNCGGYVuRQlTMGvek2tIp3GbxafGF6QWSG1sA63fI9pxGosf/qc3wX5gtHxmKB9jn1Q6d9SDuJN72StIRjl81zaJFQJswvKx5keNvbW9oOP/xBVFPbnNZq52f/MsIpo4R33Vk0CrFvj5lnEKh5t6Bx1XUpJnkzQE934h+x1B+ypLkAPpLw4VnbDBMNc/ZkGbfJuM9YsasoEYgeoAtWKkyJV2WKZfppo1pUtR7swIDAQAB"
  zone_id = local.zone_ids.dork
}

resource "cloudflare_record" "inskip_mail_dkim" {
  name    = "mail._domainkey"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=DKIM1; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn266Z2suvJyv+vISWfjajWwIdImqHjZPOJCIZ/uJ8gStp8e8X8LMnRbzG4XVmTpx5IxnACcIZz2XVzxZspub6VZsbpDbcpApSk700UpPE1zag5QCA1zKs/smOFAtN3EIcwvbQ48HrKKlQSZdV7qHsS1BPrlK1hjwi1D6JlILCg9COQR8Sscxkjvg7pNP6Q1RVK7dtbzlQnqHikHjdXUTlaf5+EVPvdP4c4Of4YI1KaJMZDcs7LpQuvGNsZmEfybA066TWIaHq+F5WSmSsUhPlTnAygGBRFic0efWn9Ij/GVwI6yDq96IWjeT9L2C7+tkfj/NAmgFoITgpAiq/2l/OwIDAQAB"
  zone_id = local.zone_ids.inskip
}

resource "cloudflare_record" "kittywitch_mail_dkim" {
  name    = "mail._domainkey"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=DKIM1; k=rsa; s=email; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApzVUOBiZic/cB3WYOADAgEu//H9dG6VNz8kzgopoKhAZ6AhM8o4nW5kAoFxjJP1c21ugghoYtlJJHaHqQg93nuaW8f48jsjQErMa12hMo8xeFviSBkv7G9gasviborHZIxJVHIIwSga+YZfjNmdCQHH4ABud95utZJc8AmCSJj/kE0NozmXL8HLaMLg9cFMMYB8Pv+GDsDaXCD4H0qJANqCQos/NCynmRkQHYEW7C4lm9FNJUB3wpPuTY4/i6QZcd5Ex4bPYcc9FO4km/rqSbmsZDfN2P+iofpXGIxtCm4iOJlBMjPDIhV/8jAK5t1wIWRq1+3F2DkppGL2F4DkwfQIDAQAB"
  zone_id = local.zone_ids.kittywitch
}


resource "cloudflare_record" "dork_mail_dmarc" {
  name    = "_dmarc"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=DMARC1; p=none"
  zone_id = local.zone_ids.dork
}

resource "cloudflare_record" "inskip_mail_dmarc" {
  name    = "_dmarc"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=DMARC1; p=none"
  zone_id = local.zone_ids.inskip
}

resource "cloudflare_record" "kittywitch_mail_dmarc" {
  name    = "_dmarc"
  proxied = false
  ttl     = 10800
  type    = "TXT"
  value   = "v=DMARC1; p=none"
  zone_id = local.zone_ids.kittywitch
}


resource "cloudflare_record" "dork_mail_submission_autodiscover" {
  name    = "_submission._tcp"
  proxied = false
  ttl     = 3600
  type    = "SRV"

  data {
    service  = "_submissions"
    proto    = "_tcp"
    priority = 5
    weight   = 0
    port     = 587
    target   = "rinnosuke.inskip.me"
  }
  zone_id = local.zone_ids.dork
}
resource "cloudflare_record" "dork_mail_submissions_autodiscover" {
  name    = "_submissions._tcp"
  proxied = false
  ttl     = 3600
  type    = "SRV"

  data {
    service  = "_submissions"
    proto    = "_tcp"
    priority = 5
    weight   = 0
    port     = 465
    target   = "rinnosuke.inskip.me"
  }
  zone_id = local.zone_ids.dork
}

resource "cloudflare_record" "dork_mail_imap_autodiscover" {
  name    = "_imap._tcp"
  proxied = false
  ttl     = 3600
  type    = "SRV"

  data {
    service  = "_imap"
    proto    = "_tcp"
    priority = 5
    weight   = 0
    port     = 143
    target   = "rinnosuke.inskip.me"
  }
  zone_id = local.zone_ids.dork
}
resource "cloudflare_record" "dork_mail_imaps_autodiscover" {
  name    = "_imaps._tcp"
  proxied = false
  ttl     = 3600
  type    = "SRV"

  data {
    service  = "_imaps"
    proto    = "_tcp"
    priority = 5
    weight   = 0
    port     = 993
    target   = "rinnosuke.inskip.me"
  }
  zone_id = local.zone_ids.dork
}

resource "cloudflare_record" "kittywitch_xmpp_server" {
  name    = "_xmpp-server._tcp"
  proxied = false
  ttl     = 3600
  type    = "SRV"

  data {
    service  = "_xmpp-server"
    proto    = "_tcp"
    priority = 5
    weight   = 0
    port     = 5269
    target   = "rinnosuke.inskip.me"
  }
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "kittywitch_xmpp_server_ssl" {
  name    = "_xmpps-server._tcp"
  proxied = false
  ttl     = 3600
  type    = "SRV"

  data {
    service  = "_xmpps-server"
    proto    = "_tcp"
    priority = 5
    weight   = 0
    port     = 5269
    target   = "rinnosuke.inskip.me"
  }
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "kittywitch_xmpp_client" {
  name    = "_xmpp-client._tcp"
  proxied = false
  ttl     = 3600
  type    = "SRV"

  data {
    service  = "_xmpp-server"
    proto    = "_tcp"
    priority = 5
    weight   = 0
    port     = 5222
    target   = "rinnosuke.inskip.me"
  }
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "kittywitch_xmpp_client_ssl" {
  name    = "_xmpps-client._tcp"
  proxied = false
  ttl     = 3600
  type    = "SRV"

  data {
    service  = "_xmpps-client"
    proto    = "_tcp"
    priority = 5
    weight   = 0
    port     = 5223
    target   = "rinnosuke.inskip.me"
  }
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "xmpp" {
  name    = "xmpp"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "rinnosuke.inskip.me"
  zone_id = local.zone_ids.kittywitch
}

resource "cloudflare_record" "xmpp_upload" {
  name    = "xmpp.upload"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "rinnosuke.inskip.me"
  zone_id = local.zone_ids.kittywitch
}
