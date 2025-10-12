data "oci_core_images" "that" {
  compartment_id = var.tenancy_ocid

  operating_system = "Oracle Linux"
  shape            = local.shapes.flex
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
  state            = "available"
}

data "cloudinit_config" "that" {
  part {
    content = file("${path.module}/cloudinit_flex_oracle.yaml")
  }
}

variable "flex_display_name" {
  type = string
}

locals {
  flex_hostname = lower(var.flex_display_name)
}

resource "oci_core_instance" "that" {
  availability_domain = "dBWL:CA-TORONTO-1-AD-1" #data.oci_identity_availability_domains.this.availability_domains.0.name
  compartment_id      = var.tenancy_ocid
  shape               = local.shapes.flex

  display_name         = var.flex_display_name
  preserve_boot_volume = false

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = data.cloudinit_config.that.rendered
  }

  agent_config {
    are_all_plugins_disabled = true
    is_management_disabled   = true
    is_monitoring_disabled   = true
  }

  availability_config {
    is_live_migration_preferred = null
  }

  create_vnic_details {
    assign_public_ip = true
    display_name     = var.flex_display_name
    hostname_label   = local.flex_hostname
    nsg_ids          = [var.nsg_id]
    subnet_id        = var.subnet_id
  }

  shape_config {
    memory_in_gbs = 24
    ocpus         = 4
  }

  source_details {
    source_id               = data.oci_core_images.that.images.0.id
    source_type             = "image"
    boot_volume_size_in_gbs = 100
  }

  lifecycle {
    ignore_changes = [
      metadata,
      source_details.0.source_id
    ]
  }
}

locals {
  flex = oci_core_instance.that
}
