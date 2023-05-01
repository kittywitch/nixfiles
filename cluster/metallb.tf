resource "helm_release" "metallb" {
    name = "metallb"
    repository = "https://metallb.github.io/metallb"
    chart = "metallb"
    create_namespace = true
    namespace = "metallb-system"

    timeout = var.helm_timeout
    cleanup_on_fail = true
    force_update = true

    values = [
        yamlencode({
        })
    ]
}