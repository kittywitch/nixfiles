resource "cloudflare_pages_project" "inskip_root" {
  account_id = "0467b993b65d8fd4a53fe24ed2fbb2a1"
  name = "inskip-root"
  production_branch = "main"

  source {
    type = "github"
    config {
        owner = "kittywitch"
        repo_name = "inskip.me"
        production_branch = "main"
        deployments_enabled = true
        pr_comments_enabled = false
        production_deployment_enabled = true
    }
  }
  build_config {
    build_command = "hugo"
    destination_dir = "public"
    root_dir = "/"
  }
  lifecycle {
    ignore_changes = [
      deployment_configs,
      source
    ]
  }
}

resource "cloudflare_pages_domain" "inskip_root" {
    account_id = "0467b993b65d8fd4a53fe24ed2fbb2a1"
    project_name = "inskip-root"
    domain = "inskip.me"
}