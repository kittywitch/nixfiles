/*
# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformgettingstarted.htm
# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
provider "oci" {
  alias = "oci_compartment"
  private_key = module.oci_compartment_bootstrap.child_compartment_key_value
  region           = var.oci_compartment_bootstrap_region
  tenancy_ocid     = module.oci_compartment_bootstrap.child_compartment_id
  user_ocid        = module.oci_compartment_bootstrap.child_user_id
  fingerprint = module.oci_compartment_bootstrap.child_compartment_key_fingerprint
}

module "oci_common_private_network" {
  source = "./oci_common_private_network"

  cidr_blocks      = [
    "10.25.0.0/16"
  ]

  display_name     = "CoreNetwork"
  dns_label        = "core"
  tenancy_ocid     = module.oci_compartment_bootstrap.child_compartment_id

  providers = {
    oci = oci.oci_compartment
  }

  depends_on = [
    module.oci_compartment_bootstrap
  ]
}
*/