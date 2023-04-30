output  "apartment_cloudflare_tunnel_id" {
    value = cloudflare_tunnel.gensokyo_apartment_tunnel.id
}
output  "apartment_cloudflare_tunnel_token" {
    value = cloudflare_tunnel.gensokyo_apartment_tunnel.tunnel_token
    sensitive = true
}