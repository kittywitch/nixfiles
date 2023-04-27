variable "cloudflare_token" {
	sensitive = true
}

provider "cloudflare" {
    api_token = var.cloudflare_token
}