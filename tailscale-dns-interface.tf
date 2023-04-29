data "tailscale_devices" "tailnet" {
}

locals {
    tailscale_devices = data.tailscale_devices.tailnet.devices
}

resource "cloudflare_record" "tailscale_device_v4_record" {
  for_each = { for device_name, device in local.tailscale_devices : device_name => device.addresses[0] if device.user == "kat@inskip.me" }
  name    = each.key
  proxied = false
  ttl     = 3600
  type    = "A"
  value   = each.value
  zone_id = "635716e7dd314fd5ec52f9434bd4527d"
}

resource "cloudflare_record" "tailscale_device_v6_record" {
  for_each = { for device_name, device in local.tailscale_devices : device_name => device.addresses[1] if device.user == "kat@inskip.me" }
  name    = each.key
  proxied = false
  ttl     = 3600
  type    = "AAAA"
  value   = each.value
  zone_id = "635716e7dd314fd5ec52f9434bd4527d"
}