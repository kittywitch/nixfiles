variable "postgres_password" {
    type = string
}

resource "kubernetes_secret" "postgres_auth_secret" {
    metadata {
        name = "postgres-auth-secret"
        namespace = "postgresql"
    }
    data = {
        postgresPassword = var.postgres_password
    }
    type = "Opaque"
}

resource "helm_release" "postgresql" {
    name = "postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "postgresql"
    create_namespace = true
    namespace = "postgresql"

    timeout = var.helm_timeout
    cleanup_on_fail = true
    force_update = true

    values = [
        yamlencode({
            global = {
                postgresql = {
                    auth = {
                        existingSecret = "postgres-auth-secret"
                    }
                }
            }
        })

    ]
}