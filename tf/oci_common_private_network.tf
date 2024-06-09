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