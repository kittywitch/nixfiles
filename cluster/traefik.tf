resource "helm_release" "traefik" {
    name = "traefik"
    repository = "https://traefik.github.io/charts"
    chart = "traefik"
    create_namespace = true
    namespace = "traefik"

    timeout = var.helm_timeout
    cleanup_on_fail = true
    force_update = true

    values = [
        yamlencode({
            deployment = {
                replicas = 1
            }
            ports = {
                traefik = {
                    web = {
                        hostPort = 80
                        expose = false
                    }
                    websecure = {
                        hostPort = 443
                        expose = false
                    }
                }
            }
        })
    ]
}