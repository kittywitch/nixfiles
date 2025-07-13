resource "oci_identity_api_key" "this" {
  key_value = local.child_compartment_public_key
  user_id   = local.child_compartment_user
}

locals {
  child_compartment_api_key = oci_identity_api_key.this
}

output "child_compartment_key_fingerprint" {
  value = local.child_compartment_api_key.fingerprint
}

output "child_compartment_key_id" {
  value = local.child_compartment_api_key.id
}

output "child_compartment_key_value" {
  value = local.child_compartment_api_key.key_value
}

output "child_compartment_key_state" {
  value = local.child_compartment_api_key.state
}