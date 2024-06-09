locals {
  display_name = ["Mei", "Mai"]
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

resource "oci_core_instance" "this" {
  count = 2

  availability_domain = local.availability_domain_micro
  compartment_id = var.tenancy_ocid
  shape               = local.shapes.micro

  display_name         = local.display_name[count.index]
  preserve_boot_volume = false

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
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
    display_name   = format("Ubuntu %d", count.index + 1)
    hostname_label = format("ubuntu-%d", count.index + 1)
    nsg_ids        = [oci_core_network_security_group.this.id]
    subnet_id      = oci_core_subnet.this.id
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