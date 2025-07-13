resource "tls_private_key" "this" {
  # https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_api_key#key_value
  # "The public key. Must be an RSA key in PEM format."
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  child_compartment_private_key = tls_private_key.this.private_key_pem
  child_compartment_public_key  = tls_private_key.this.public_key_pem
}

output "child_compartment_private_key" {
  value = local.child_compartment_private_key
}

output "child_compartment_public_key" {
  value = local.child_compartment_public_key
}
