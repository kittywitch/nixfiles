module "oci_common_private_network" {
  source = "./oci_common_private_network"

  cidr_blocks = [
    "10.25.0.0/16"
  ]
  ipv6_cidr_blocks = [
    "2001:db8:123:1337::/64"
  ]

  display_name = "CoreNetwork"
  dns_label    = "core"
  tenancy_ocid = module.oci_compartment_bootstrap.child_compartment_id

  providers = {
    oci = oci.oci_compartment
  }

  depends_on = [
    module.oci_compartment_bootstrap
  ]
}
