variable "tailscale_api_key" {
    type = string
}

variable "tailnet" {
    type = string
}


provider "tailscale" {
    api_key = var.tailscale_api_key
    tailnet = var.tailnet
}

resource "tailscale_tailnet_key" "cluster_reusable" {
    reusable = true
    ephemeral = true
    preauthorized = true
}

resource "kubernetes_secret" "tailscale_auth" {
    metadata {
        name = "tailscale-auth"
        namespace = kubernetes_namespace.pihole.metadata[0].name
    }
    data = {
        TS_AUTHKEY = tailscale_tailnet_key.cluster_reusable.key
    }
    type = "Opaque"
}

