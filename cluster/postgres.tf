variable "postgres_password" {
    type = string
}

resource "kubernetes_namespace" "postgres_namespace" {
    metadata { 
        name = "postgresql"
    }
}

resource "kubernetes_secret" "postgres_auth_secret" {
    depends_on = [
        kubernetes_namespace.postgres_namespace
    ]

    metadata {
        name = "postgres-auth-secret"
        namespace = "postgresql"
    }
    data = {
        postgres-password = var.postgres_password
    }
    type = "Opaque"
}

resource "helm_release" "postgresql" {
    depends_on = [
        kubernetes_namespace.postgres_namespace,
        kubernetes_secret.postgres_auth_secret
    ]

    name = "postgresql"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "postgresql"
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