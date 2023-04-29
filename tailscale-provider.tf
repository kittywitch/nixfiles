variable "tailscale_api_key" {
    sensitive = true
}

variable "tailnet" {
    sensitive = false
}

provider "tailscale" {
    api_key = var.tailscale_api_key
    tailnet = var.tailnet
}