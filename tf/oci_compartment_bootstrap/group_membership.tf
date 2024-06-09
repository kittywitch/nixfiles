resource "oci_identity_user_group_membership" "this" {
  user_id = oci_identity_user.this.id
  group_id = oci_identity_group.this.id
}