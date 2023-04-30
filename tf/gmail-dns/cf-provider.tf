terraform {
    required_providers {
        cloudflare = {
        source = "cloudflare/cloudflare"
        version = "4.4.0"
        }
    }
}

provider "cloudflare" {
    email = "kat@inskip.me"
    api_key = var.cloudflare_api_key
}
