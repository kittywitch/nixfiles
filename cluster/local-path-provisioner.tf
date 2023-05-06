resource "helm_release" "local_path_provisioner" {
    name = "local-path-provisioner"
    repository = "${path.module}/lpp/deploy/chart"
    chart = "local-path-provisioner"
    create_namespace = true
    namespace = "local-path-storage"

    timeout = var.helm_timeout
    cleanup_on_fail = true
    force_update = true
}