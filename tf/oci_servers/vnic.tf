data "oci_core_vnic_attachments" "flex" {
  compartment_id = var.tenancy_ocid
  instance_id    = local.flex.id
}

resource "oci_core_ipv6" "ipv6_flex" {
  vnic_id = data.oci_core_vnic_attachments.flex.vnic_attachments[0].vnic_id
  ipv6subnet_cidr = var.v6_cidr
  subnet_id = var.subnet_id
}

output "flex_public_ipv6" {
  value = oci_core_ipv6.ipv6_flex.ip_address
}

data "oci_core_vnic_attachments" "micros" {
  count          = 2
  compartment_id = var.tenancy_ocid
  instance_id    = local.micros[count.index].id
}

resource "oci_core_ipv6" "ipv6_micros" {
  count = 2
  vnic_id = data.oci_core_vnic_attachments.micros[count.index].vnic_attachments[0].vnic_id
  ipv6subnet_cidr = var.v6_cidr
  subnet_id = var.subnet_id
}

output "micro_public_ipv6s" {
  value = oci_core_ipv6.ipv6_micros[*].ip_address
}
