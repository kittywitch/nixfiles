variable "cloudflare_api_token" {
    type = string
}

resource "kubernetes_secret" "cloudflare_api_token" {
    metadata {
        name = "cloudflare-api-token"
        namespace = "traefik"
    }
    data = {
        api-token = var.cloudflare_api_token
    }
    type = "Opaque"
}

/*resource "kubernetes_manifest" "cert_manager_cloudflare_issuer" {
    depends_on = [
        helm_release.cert-manager
    ]

    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "Issuer"
        "metadata" = {
            "name" = "cloudflare"
            "namespace" = "traefik"
        }
        "spec" = {
            "acme" = {
                "email" = "acme@inskip.me"
                "privateKeySecretRef" = {
                    "name" = "cloudflare-key"
                }
                "server" = "https://acme-v02.api.letsencrypt.org/directory"
                "solvers" = [
                    {
                        "dns01" = {
                            "cloudflare" = {
                                "apiTokenSecretRef" = {
                                    "key" = "api-token"
                                    "name" = "cloudflare-api-token"
                                }
                                "email" = "kat@inskip.me"
                            }
                        }
                    },
                ]
            }
        }
    }
}*/