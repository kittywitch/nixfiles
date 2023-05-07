
variable "tailscale_api_key" {
    type = string
}

provider "tailscale" {
    api_key = var.tailscale_api_key
    tailnet = "inskip.me"
}

resource "tailscale_tailnet_key" "cluster_reusable" {
    reusable = true
    ephemeral = true
    preauthorized = true
}

resource "kubernetes_secret" "tailscale_auth" {
    metadata {
        name = "tailscale-auth"
        namespace = "pihole"
    }
    data = {
        TS_AUTHKEY = tailscale_tailnet_key.cluster_reusable.key
    }
    type = "Opaque"
}

