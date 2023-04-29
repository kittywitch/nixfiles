resource "cloudflare_pages_project" "kittywitch" {
  account_id = "0467b993b65d8fd4a53fe24ed2fbb2a1"
  name = "kittywitch"
  production_branch = "main"

  source {
    type = "github"
    config {
        owner = "kittywitch"
        repo_name = "kittywit.ch"
        production_branch = "main"
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

resource "cloudflare_pages_domain" "kittywitch_root" {
    account_id = "0467b993b65d8fd4a53fe24ed2fbb2a1"
    project_name = "kittywitch"
    domain = "kittywit.ch"
}

resource "cloudflare_record" "kittywitch_root_pages" {
  name    = "kittywit.ch"
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  value   = "kittywitch.pages.dev"
  zone_id = "7e44e5503a0bba73d2025d0a9679205e"
}