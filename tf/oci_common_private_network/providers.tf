terraform {
  required_providers {
    # Vendor: Hashicorp
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    # Vendor: Oracle
    oci = {
      source  = "opentofu/oci"
      version = ">= 8.0.0"
    }
  }
}
