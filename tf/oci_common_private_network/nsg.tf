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

resource "oci_core_network_security_group_security_rule" "icmp_in" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.this.id
  protocol                  = local.protocol_number.icmp
  source                    = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "ssh_in" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.this.id
  protocol                  = local.protocol_number.tcp
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

output "nsg_id" {
  value = oci_core_network_security_group.this.id
}