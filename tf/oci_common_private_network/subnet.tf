resource "oci_core_subnet" "this" {
  cidr_block     = oci_core_vcn.this.cidr_blocks.0
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.this.id

  display_name = oci_core_vcn.this.display_name
  dns_label    = "subnet"
}