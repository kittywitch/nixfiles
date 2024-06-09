resource "oci_identity_user" "this" {
  compartment_id = local.child_compartment_id
  description = "The user for Terraform to use"
  name = "terraform"
}

locals {
  child_compartment_user = oci_identity_user.this.id
}

output "child_user_id" {
  value = local.child_compartment_user
}