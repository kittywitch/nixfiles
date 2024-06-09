variable "kat_pgp_ssh_public_key" {
  type = string
}

module "oci_servers" {
  source = "./oci_servers"

  micro_display_names = ["Mei", "Mai"]
  flex_display_name = "Daiyousei"

  tenancy_ocid        = module.oci_compartment_bootstrap.child_compartment_id
  nsg_id              = module.oci_common_private_network.nsg_id
  ssh_authorized_keys = [var.kat_pgp_ssh_public_key]
  subnet_id           = module.oci_common_private_network.subnet_id
}