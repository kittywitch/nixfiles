terraform {
  required_providers {
    # Vendor: Hashicorp
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
    # Vendor: Oracle
    oci = {
      source = "oracle/oci"
      version = "5.45.0"
      configuration_aliases = [ oci.oci_root, oci.oci_compartment ]
    }
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.38.2"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.13.7"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.4.0"
    }
  }

  #/*
  # Settings for local applies
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "kittywitch"
    workspaces {
      name = "nixfiles-tf"
    }
  }
  #*/

  /*
  # Settings for remote applies
  cloud {
    organization = "kittywitch"
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for Terraform Cloud
    hostname = "app.terraform.io"

    workspaces {
      name = "nixfiles-tf"
    }
  }
  */
}