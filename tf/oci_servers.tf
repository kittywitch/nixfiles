variable "kat_pgp_ssh_public_key" {
  type = string
}

module "oci_servers" {
  source = "./oci_servers"

  micro_display_names = ["Mei", "Mai"]
  flex_display_name   = "Daiyousei"

  tenancy_ocid        = module.oci_compartment_bootstrap.child_compartment_id
  nsg_id              = module.oci_common_private_network.nsg_id
  ssh_authorized_keys = var.kat_pgp_ssh_public_key
  subnet_id           = module.oci_common_private_network.subnet_id
  v6_cidr = module.oci_common_private_network.v6_cidr

  providers = {
    oci = oci.oci_compartment
  }

  depends_on = [
    module.oci_compartment_bootstrap
  ]
}

output "daiyousei_public_ipv4" {
  value = module.oci_servers.flex_public_ipv4
}

output "daiyousei_public_ipv6" {
  value = module.oci_servers.flex_public_ipv6
}

output "mei_public_ipv4" {
  value = module.oci_servers.micro_public_ipv4s[0]
}

output "mei_public_ipv6" {
  value = module.oci_servers.micro_public_ipv6s[0]
}

output "mai_public_ipv4" {
  value = module.oci_servers.micro_public_ipv4s[1]
}

output "mai_public_ipv6" {
  value = module.oci_servers.micro_public_ipv6s[1]
}

locals {
  server_ipv4s = {
    daiyousei = module.oci_servers.flex_public_ipv4
    mei       = module.oci_servers.micro_public_ipv4s[0]
    mai       = module.oci_servers.micro_public_ipv4s[1]
  }
  server_ipv6s = {
    daiyousei = module.oci_servers.flex_public_ipv6
    mei       = module.oci_servers.micro_public_ipv6s[0]
    mai       = module.oci_servers.micro_public_ipv6s[1]
  }
  server_json = {
    daiyousei = {
      v4 = module.oci_servers.flex_public_ipv4
      v6 = module.oci_servers.flex_public_ipv6
    }
    mei = {
      v4 = module.oci_servers.micro_public_ipv4s[0]
      v6 = module.oci_servers.micro_public_ipv6s[0]
    }
    mai = {
      v4 = module.oci_servers.micro_public_ipv4s[1]
      v6 = module.oci_servers.micro_public_ipv6s[1]
    }
  }
}

resource "cloudflare_record" "oci" {
  for_each = local.server_ipv4s
  name     = each.key
  proxied  = false
  ttl      = 3600
  type     = "A"
  value    = each.value
  zone_id  = local.zone_ids.inskip
}

resource "local_file" "oracle_servers" {
  filename = "${path.module}/servers-oracle.json"
  content = jsonencode(local.server_json)
}
