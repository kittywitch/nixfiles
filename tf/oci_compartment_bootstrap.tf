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

variable "oci_compartment_bootstrap_user_email" {
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
  user_email = var.oci_compartment_bootstrap_user_email

  providers = {
    oci = oci.oci_root
  }
}

output "oci_compartment_bootstrap_child_user_id" {
  value = module.oci_compartment_bootstrap.child_user_id
  sensitive = true
}

output "oci_compartment_bootstrap_child_compartment_id" {
  value = module.oci_compartment_bootstrap.child_compartment_id
  sensitive = true
}

output "oci_compartment_bootstrap_child_compartment_key_id" {
  value = module.oci_compartment_bootstrap.child_compartment_key_id
  sensitive = true
}

output "oci_compartment_bootstrap_child_compartment_key_fingerprint" {
  value = module.oci_compartment_bootstrap.child_compartment_key_fingerprint
  sensitive = true
}

output "oci_compartment_bootstrap_child_compartment_key_value" {
  value = module.oci_compartment_bootstrap.child_compartment_key_value
  sensitive = true
}

output "oci_compartment_bootstrap_child_compartment_key_state" {
  value = module.oci_compartment_bootstrap.child_compartment_key_state
  sensitive = true
}

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformgettingstarted.htm
# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
provider "oci" {
  alias = "oci_compartment"
  private_key = module.oci_compartment_bootstrap.child_compartment_private_key
  region           = var.oci_compartment_bootstrap_region
  tenancy_ocid     = module.oci_compartment_bootstrap.child_compartment_id
  user_ocid        = module.oci_compartment_bootstrap.child_user_id
  fingerprint = module.oci_compartment_bootstrap.child_compartment_key_fingerprint
}
