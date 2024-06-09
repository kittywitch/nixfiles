locals {
  takeover_ubuntu = yamlencode({

  })
}

data "oci_core_images" "this" {
  compartment_id = var.tenancy_ocid

  operating_system = "Canonical Ubuntu"
  shape            = local.shapes.micro
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
  state            = "available"

  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-([\\.0-9-]+)$"]
    regex  = true
  }
}

data "cloudinit_config" "this" {
  part {
    content = local.takeover_ubuntu
  }
}

variable "micro_display_names" {
  type = list(string)
}

resource "oci_core_instance" "this" {
  count = 2

  availability_domain = local.availability_domain_micro
  compartment_id = var.tenancy_ocid
  shape               = local.shapes.micro

  display_name         = var.micro_display_names[count.index]
  preserve_boot_volume = false

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = data.cloudinit_config.this.rendered
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
    display_name = var.micro_display_names[count.index]
    hostname_label = lower(var.micro_display_names[count.index])
    nsg_ids        = [var.nsg_id]
    subnet_id      = var.subnet_id
  }

  source_details {
    source_id               = data.oci_core_images.this.images.0.id
    source_type             = "image"
    boot_volume_size_in_gbs = 50
  }

  lifecycle {
    ignore_changes = [source_details.0.source_id]
  }
}