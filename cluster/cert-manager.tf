resource "helm_release" "cert-manager" {
    name = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart = "cert-manager"
    create_namespace = true
    namespace = "cert-manager"

    timeout = var.helm_timeout
    cleanup_on_fail = true
    force_update = true

    values = [
        yamlencode({
            installCRDS = true
        })
    ]
}