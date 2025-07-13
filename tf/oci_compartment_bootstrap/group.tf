resource "oci_identity_group" "this" {
  compartment_id = var.tenancy_ocid

  name        = "terraform"
  description = "terraform"
}