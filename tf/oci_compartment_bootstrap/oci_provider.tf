variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "private_key" {
  type = string
}

variable "region" {
  type = string
}

variable "fingerprint" {
  type = string
}

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformgettingstarted.htm
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid = var.user_ocid
  private_key = var.private_key
  region = var.region
  fingerprint = var.fingerprint
}