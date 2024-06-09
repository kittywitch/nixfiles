resource "oci_core_network_security_group" "this" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.this.id

  display_name = oci_core_vcn.this.display_name
}

locals {
  protocol_number = {
    icmp   = 1
    icmpv6 = 58
    tcp    = 6
    udp    = 17
  }
}

resource "oci_core_network_security_group_security_rule" "this" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.this.id
  protocol                  = local.protocol_number.icmp
  source                    = "0.0.0.0/0"
}

output "nsg_id" {
  value = oci_core_network_security_group.this.id
}