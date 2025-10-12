variable "passphrase" {
  sensitive = true
}

terraform {
  required_providers {
    # Vendor: Hashicorp
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    # Vendor: Oracle
    oci = {
      source  = "oracle/oci"
      version = "5.45.0"
    }
    /*hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.38.2"
    }*/
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.13.7"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.4.0"
    }
  }
  encryption {
    key_provider "pbkdf2" "kw" {
      passphrase = var.passphrase
    }

    method "aes_gcm" "kw" {
      keys = key_provider.pbkdf2.kw
    }

    state {
      method = method.aes_gcm.kw
    }
  }
}
