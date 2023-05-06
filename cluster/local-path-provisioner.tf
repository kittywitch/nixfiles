resource "helm_release" "local_path_provisioner" {
    name = "local-path-storage"
    repository = "./lpp"
    chart = "local-path-storage"
    create_namespace = true
    namespace = "local-path-storage"

    timeout = var.helm_timeout
    cleanup_on_fail = true
    force_update = true
}