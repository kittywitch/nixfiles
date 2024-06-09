variable "tenancy_ocid" {
  type = string
}

variable "cidr_blocks" {
  type = list(string)
}

variable "display_name" {
  type = string
}

variable "dns_label" {
  type = string
}

resource "oci_core_vcn" "this" {
  compartment_id = var.tenancy_ocid

  cidr_blocks = var.cidr_blocks
  display_name = var.display_name
  dns_label = var.dns_label
}

locals {
  vcn = oci_core_vcn.this
}

output "vcn_id" {
  value = local.vcn.id
}