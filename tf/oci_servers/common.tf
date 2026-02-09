locals {
  shapes = {
    flex : "VM.Standard.A1.Flex",
    micro : "VM.Standard.E2.1.Micro",
  }

  /*availability_domain_micro = one(
    [
      for m in data.oci_core_shapes.this :
      m.availability_domain
      if contains(m.shapes[*].name, local.shapes.micro)
    ]
  )*/
}

variable "tenancy_ocid" {
  type = string
}

variable "ssh_authorized_keys" {
  type = string
}

variable "nsg_id" {
  type = any
}

variable "subnet_id" {
  type = any
}

variable "v6_cidr" {
  type = any
}

/*
data "oci_identity_availability_domains" "this" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_shapes" "this" {
  for_each = toset(data.oci_identity_availability_domains.this.availability_domains[*].name)

  compartment_id = var.tenancy_ocid

  availability_domain = each.key
}
*/
