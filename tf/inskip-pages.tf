resource "cloudflare_pages_project" "inskip_root" {
  account_id        = local.account_id
  name              = "inskip-root"
  production_branch = "main"

  source {
    type = "github"
    config {
      owner                         = "kittywitch"
      repo_name                     = "inskip.me"
      production_branch             = "main"
      deployments_enabled           = true
      pr_comments_enabled           = false
      production_deployment_enabled = true
    }
  }
  build_config {
    build_command   = "hugo"
    destination_dir = "public"
    root_dir        = "/"
  }
  lifecycle {
    ignore_changes = [
      deployment_configs,
      source
    ]
  }
}

resource "cloudflare_pages_domain" "inskip_root" {
  account_id   = local.account_id
  project_name = "inskip-root"
  domain       = local.zones.inskip
}

resource "cloudflare_record" "inskip_root_pages" {
  name    = local.zones.inskip
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = cloudflare_pages_project.inskip_root.subdomain
  zone_id = local.zone_ids.inskip
}