resource "oci_core_default_security_list" "this" {
  manage_default_resource_id = local.vcn.default_security_list_id

  dynamic "ingress_security_rules" {
    for_each = [
      { from = 60000
      to = 61000 }
    ]
    iterator = port
    content {
      protocol = local.protocol_number.udp
      source   = "0.0.0.0/0"

      description = "Mosh traffic from any origin"

      udp_options {
        max = port.value.to
        min = port.value.from
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = [22, 80, 443]
    iterator = port
    content {
      protocol = local.protocol_number.tcp
      source   = "0.0.0.0/0"

      description = "SSH and HTTPS traffic from any origin"

      tcp_options {
        max = port.value
        min = port.value
      }
    }
  }

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"

    description = "All traffic to any destination"
  }
}