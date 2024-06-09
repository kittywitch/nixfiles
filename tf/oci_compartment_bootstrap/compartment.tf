variable "tenancy_ocid" {
  type = string
}

resource "oci_identity_compartment" "this" {
  # Compartment ID is Tenancy ID for this case
  compartment_id = var.tenancy_ocid
  description = "Compartment for Terraform usage"
  name = "kittywitch-tf"

}

locals {
  child_compartment_id = oci_identity_compartment.this.compartment_id
}

output "child_compartment_id" {
  value = local.child_compartment_id
}