terraform {
    required_providers {  
        cloudflare = {
        source = "cloudflare/cloudflare"
        version = "4.4.0"
        }
    }
}

provider "cloudflare" {
    api_token = var.cloudflare_token
}
