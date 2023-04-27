resource "cloudflare_record" "terraform_managed_resource_4078b739fc60f37d90a25448e08b6616" {
  name    = "yukari"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = "5.78.94.220"
  zone_id = "84e33c7736e439f633867310dbf7d672"
}

resource "cloudflare_record" "terraform_managed_resource_1206b053e895e4f6a9d1b3b4856db871" {
  name    = "yukari"
  proxied = false
  ttl     = 3600
  type    = "AAAA"
  value   = "2a01:4ff:1f0:e7bb::1"
  zone_id = "84e33c7736e439f633867310dbf7d672"
}

resource "cloudflare_record" "terraform_managed_resource_ff749881351460f7b8033925a981c71b" {
  name    = "gensokyo.zone"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "a3ae32ce-fe82-4f2c-ad54-3adf4a45fcbc.cfargotunnel.com"
  zone_id = "84e33c7736e439f633867310dbf7d672"
}

resource "cloudflare_record" "terraform_managed_resource_de3e257652bf06bd53370e8f94ed953a" {
  name    = "home"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "a3ae32ce-fe82-4f2c-ad54-3adf4a45fcbc.cfargotunnel.com"
  zone_id = "84e33c7736e439f633867310dbf7d672"
}

resource "cloudflare_record" "terraform_managed_resource_f82bd333e5b66b679da66366b49556ce" {
  name    = "id"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "a3ae32ce-fe82-4f2c-ad54-3adf4a45fcbc.cfargotunnel.com"
  zone_id = "84e33c7736e439f633867310dbf7d672"
}

resource "cloudflare_record" "terraform_managed_resource_28db45adacd9a72d6886e54c186507ad" {
  name    = "login"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "a3ae32ce-fe82-4f2c-ad54-3adf4a45fcbc.cfargotunnel.com"
  zone_id = "84e33c7736e439f633867310dbf7d672"
}

resource "cloudflare_record" "terraform_managed_resource_5b75677ad04ec46e785f01e3ab7734d6" {
  name    = "warez"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "a3ae32ce-fe82-4f2c-ad54-3adf4a45fcbc.cfargotunnel.com"
  zone_id = "84e33c7736e439f633867310dbf7d672"
}

resource "cloudflare_record" "terraform_managed_resource_c8069088a8868436e9ac08ed575465b9" {
  name    = "z2m"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "a3ae32ce-fe82-4f2c-ad54-3adf4a45fcbc.cfargotunnel.com"
  zone_id = "84e33c7736e439f633867310dbf7d672"
}

