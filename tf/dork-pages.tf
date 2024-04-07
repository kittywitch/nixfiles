resource "cloudflare_pages_project" "dorkdev" {
  account_id = local.account_id
  name = "dorkdev"
  production_branch = "site"

  source {
    type = "github"
    config {
        owner = "kittywitch"
        repo_name = "dork.dev"
        production_branch = "site"
        deployments_enabled = true
        pr_comments_enabled = false
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

resource "cloudflare_pages_domain" "dorkdev_root" {
    account_id = local.account_id
    project_name = "dorkdev"
    domain = local.zones.dork
}

resource "cloudflare_record" "dorkdev_root_pages" {
  name    = local.zones.dork
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "${cloudflare_pages_project.dorkdev.name}.pages.dev"
  zone_id = local.zone_ids.dork
}