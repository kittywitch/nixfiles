locals {
  account_id = "0467b993b65d8fd4a53fe24ed2fbb2a1"
  zones = {
    dork       = "dork.dev"
    inskip     = "inskip.me"
    kittywitch = "kittywit.ch"
  }
  zone_ids = {
    dork       = cloudflare_zone.dork_zone.id
    inskip     = cloudflare_zone.inskip_zone.id
    kittywitch = cloudflare_zone.kittywitch_zone.id
  }
}

resource "cloudflare_zone" "dork_zone" {
  account_id = local.account_id
  paused     = false
  plan       = "free"
  type       = "full"
  zone       = local.zones.dork
}

resource "cloudflare_zone" "inskip_zone" {
  account_id = local.account_id
  paused     = false
  plan       = "free"
  type       = "full"
  zone       = local.zones.inskip
}

resource "cloudflare_zone" "kittywitch_zone" {
  account_id = local.account_id
  paused     = false
  plan       = "free"
  type       = "full"
  zone       = local.zones.kittywitch
}
