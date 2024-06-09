locals {
  policy_multi_line_statement = <<EOF
Allow group ${oci_identity_group.this.name} to manage vcns in compartment id ${var.tenancy_ocid} where ALL {
ANY { request.operation = 'CreateNetworkSecurityGroup', request.operation = 'DeleteNetworkSecurityGroup' }
}
  EOF

}

resource "oci_identity_policy" "terraform-admin" {
  compartment_id = var.tenancy_ocid

  name = "terraform-admin"
  description = "terraform-admin"

  statements = [
    "Allow group ${oci_identity_group.this.name} to manage all-resources in compartment id ${local.child_compartment_id}",
    "Allow group ${oci_identity_group.this.name} to read virtual-network-family in compartment id ${var.tenancy_ocid}",
    local.policy_multi_line_statement,
  ]
}
