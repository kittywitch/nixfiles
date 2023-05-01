resource "helm_release" "traefik" {
    name = "traefik"
    repository = "https://traefik.github.io/charts"
    chart = "traefik"
    create_namespace = true
    namespace = "traefik"

    timeout = var.helm_timeout

    values = [
        yamlencode({
            deployment = {
                replicas = 1
            }
        })
    ]
}