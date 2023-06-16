variable "authentik_postgresql_password" {
    type = string
}

variable "authentik_secret_key" {
    type = string
}

resource "helm_release" "authentik" {
    depends_on = [
        helm_release.local_path_provisioner
    ]

    name = "authentik"
    repository = "https://charts.goauthentik.io"
    chart = "authentik"
    create_namespace = true
    namespace = "authentik"

    timeout = var.helm_timeout
    cleanup_on_fail = true
    force_update = true

    values = [
        yamlencode({
            authentik = {
                secret_key = var.authentik_secret_key
                error_reporting = {
                    enabled = true
                }
                postgresql = {
                    password = var.authentik_postgresql_password
                }
            }
            redis = {
                enabled = true 
                master = {
                    persistence = {
                        enabled = true
                        storageClass = "local-path"
                        accessModes = [
                            "ReadWriteOnce"
                        ]
                    }
                }
            }
            postgresql = {
                enabled = true
                password = var.authentik_postgresql_password
                postgresqlPassword = var.authentik_postgresql_password
                persistence = {
                    enabled = true
                    storageClass = "local-path"
                    accessModes = [
                        "ReadWriteOnce"
                    ]
                }
            }
            ingress = {
                enabled = true
                hosts = [
                    {
                        host = "auth.inskip.me"
                        paths = [
                            {
                                path = "/"
                                pathType = "Prefix"
                            }
                        ]
                    }
                ]
            }
        })
    ]
}