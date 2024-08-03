data "tailscale_devices" "tailnet" {
}

locals {
    tailscale_devices = data.tailscale_devices.tailnet.devices
}

resource "cloudflare_record" "tailscale_device_v4_record" {
  for_each = { for device_name, device in local.tailscale_devices : split(".", device.name)[0] => device.addresses[0] if device.user == "kat@gensokyo.zone" }
  name    = "${each.key}.devices"
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = each.value
  zone_id = local.zone_ids.inskip
}

resource "cloudflare_record" "tailscale_device_v6_record" {
  for_each = { for device_name, device in local.tailscale_devices : split(".", device.name)[0] => device.addresses[1] if device.user == "kat@gensokyo.zone" }
  name    = "${each.key}.devices"
  proxied = false
  ttl     = 3600
  type    = "AAAA"
  value   = each.value
  zone_id = local.zone_ids.inskip
}