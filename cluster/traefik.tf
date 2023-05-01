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
            service = {
                type = "NodePort"
            }
            ports = {
                traefik = {
                    traefik = {
                        hostPort = 9000
                        hostIP = "100.105.14.66"
                        expose = true
                    }
                    web = {
                        hostPort = 80
                        expose = true
                    }
                    websecure = {
                        hostPort = 443
                        expose = true
                    }
                }
            }
        })
    ]
}