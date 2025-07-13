variable "tailscale_oauth_client_id" {
  sensitive = true
}

variable "tailscale_oauth_client_secret" {
  sensitive = true
}

variable "tailnet" {
  sensitive = false
}

provider "tailscale" {
  oauth_client_id     = var.tailscale_oauth_client_id
  oauth_client_secret = var.tailscale_oauth_client_secret
  tailnet             = var.tailnet
}