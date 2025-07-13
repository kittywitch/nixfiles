resource "cloudflare_pages_project" "kittywitch" {
  account_id        = local.account_id
  name              = "kittywitch"
  production_branch = "main"

  source {
    type = "github"
    config {
      owner                         = "kittywitch"
      repo_name                     = "kittywit.ch"
      production_branch             = "main"
      deployments_enabled           = true
      pr_comments_enabled           = false
      production_deployment_enabled = true

    }
  }
  lifecycle {
    ignore_changes = [
      deployment_configs,
      source
    ]
  }
}

resource "cloudflare_pages_domain" "kittywitch_root" {
  account_id   = local.account_id
  project_name = "kittywitch"
  domain       = local.zones.kittywitch
}

resource "cloudflare_record" "kittywitch_root_pages" {
  name    = local.zones.kittywitch
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "${cloudflare_pages_project.kittywitch.name}.pages.dev"
  zone_id = local.zone_ids.kittywitch
}