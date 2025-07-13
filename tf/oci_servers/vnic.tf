data "oci_core_vnic_attachments" "flex" {
  compartment_id = var.tenancy_ocid
  instance_id    = local.flex.id
}

data "oci_core_vnic_attachments" "micros" {
  count          = 2
  compartment_id = var.tenancy_ocid
  instance_id    = local.micros[count.index].id
}