terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.13.7"
    }
  }
}
