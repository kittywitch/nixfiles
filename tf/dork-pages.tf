resource "cloudflare_pages_project" "dorkdev" {
  account_id        = local.account_id
  name              = "dorkdev"
  production_branch = "main"

  source {
    type = "github"
    config {
      owner                         = "kittywitch"
      repo_name                     = "dork.dev"
      production_branch             = "main"
      deployments_enabled           = true
      pr_comments_enabled           = false
      production_deployment_enabled = true

    }
  }
  build_config {
    build_command   = "zola build"
    destination_dir = "public"
    #root_dir = "/"
  }
  deployment_configs {
    preview {
    }
    production {
      environment_variables = {
        UNSTABLE_PRE_BUILD = "asdf plugin add zola https://github.com/salasrod/asdf-zola && asdf install zola 0.20.0 && asdf global zola 0.20.0"
        ZOLA_VERSION       = "0.20.0"
      }
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
  account_id   = local.account_id
  project_name = "dorkdev"
  domain       = local.zones.dork

}

resource "cloudflare_record" "dorkdev_root_pages" {
  name    = local.zones.dork
  proxied = false
  ttl     = 3600
  type    = "CNAME"
  #  value   = "${cloudflare_pages_project.dorkdev.name}.pages.dev"
  value   = "rinnosuke.inskip.me"
  zone_id = local.zone_ids.dork
}
