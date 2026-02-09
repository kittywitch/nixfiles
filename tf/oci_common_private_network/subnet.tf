resource "oci_core_subnet" "this" {
  cidr_block     = oci_core_vcn.this.cidr_blocks.0
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.this.id
ipv6cidr_blocks = [ cidrsubnet(oci_core_vcn.this.ipv6cidr_blocks.0, 8, 0) ]
  display_name = oci_core_vcn.this.display_name
  dns_label    = "subnet"
}

locals {
  subnet = oci_core_subnet.this
}

output "subnet_id" {
  value = local.subnet.id
}

output "v6_cidr" {
  value = local.subnet.ipv6cidr_block
}
