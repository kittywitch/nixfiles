locals {
  flex_public_ipv4 = oci_core_instance.that.public_ip
  micro_public_ipv4s = oci_core_instance.this[*].public_ip
}

output "flex_public_ipv4" {
  value = local.flex_public_ipv4
}

output "micro_public_ipv4s" {
  value = local.micro_public_ipv4s
}