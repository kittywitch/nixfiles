variable "cloudflare_api_key" {
  sensitive = true
}

provider "cloudflare" {
  email   = "kat@inskip.me"
  api_key = var.cloudflare_api_key
}