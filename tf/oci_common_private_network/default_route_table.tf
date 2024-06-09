
resource "oci_core_default_route_table" "this" {
  manage_default_resource_id = local.vcn.default_route_table_id

  display_name = oci_core_vcn.this.display_name

  route_rules {
    network_entity_id = local.igw.id

    description = "Internet v4"
    destination = "0.0.0.0/0"
  }
  route_rules {
    network_entity_id = local.igw.id

    description = "Internet v6"
    destination = "::/0"
  }
}