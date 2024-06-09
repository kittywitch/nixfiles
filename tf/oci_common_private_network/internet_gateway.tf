resource "oci_core_internet_gateway" "this" {
  display_name = "internet"
  compartment_id = var.tenancy_ocid
  vcn_id = local.vcn.id
}

locals {
  igw = oci_core_internet_gateway.this
}

output "internet_gateway_id" {
  value = local.igw.id
}