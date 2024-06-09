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
    }
  }
}
