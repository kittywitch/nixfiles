# Populate in via variables to avoid secret leakage

variable "oci_compartment_bootstrap_private_key" {
  type = string
}

variable "oci_compartment_bootstrap_region" {
  type = string
}

variable "oci_compartment_bootstrap_tenancy_ocid" {
  type = string
}

variable "oci_compartment_bootstrap_user_ocid" {
  type = string
}

variable "oci_compartment_bootstrap_fingerprint" {
  type = string
}

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformgettingstarted.htm
# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
provider "oci" {
  alias = "oci_root"
  private_key = var.oci_compartment_bootstrap_private_key
  region           = var.oci_compartment_bootstrap_region
  tenancy_ocid     = var.oci_compartment_bootstrap_tenancy_ocid
  user_ocid        = var.oci_compartment_bootstrap_user_ocid
  fingerprint = var.oci_compartment_bootstrap_fingerprint
}

# OCI Compartment Bootstrap
module "oci_compartment_bootstrap" {
  source = "./oci_compartment_bootstrap"

  tenancy_ocid     = var.oci_compartment_bootstrap_tenancy_ocid

  providers = {
    oci = oci.oci_root
  }
}

output "oci_compartment_bootstrap_child_user_id" {
  value = module.oci_compartment_bootstrap.child_user_id
}

output "oci_compartment_bootstrap_child_compartment_id" {
  value = module.oci_compartment_bootstrap.child_compartment_id
}

output "oci_compartment_bootstrap_child_compartment_key_id" {
  value = module.oci_compartment_bootstrap.child_compartment_key_id
}

output "oci_compartment_bootstrap_child_compartment_key_fingerprint" {
  value = module.oci_compartment_bootstrap.child_compartment_key_fingerprint
}

output "oci_compartment_bootstrap_child_compartment_key_value" {
  value = module.oci_compartment_bootstrap.child_compartment_key_value
}

output "oci_compartment_bootstrap_child_compartment_key_state" {
  value = module.oci_compartment_bootstrap.child_compartment_key_state
}