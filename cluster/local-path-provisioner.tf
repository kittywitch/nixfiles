resource "kubernetes_namespace" "local_path_storage" {
  metadata {
    name = "local-path-storage"
  }
}

resource "kubernetes_service_account" "local_path_provisioner_service_account" {
  metadata {
    name      = "local-path-provisioner-service-account"
    namespace = "local-path-storage"
  }
}

resource "kubernetes_cluster_role" "local_path_provisioner_role" {
  metadata {
    name = "local-path-provisioner-role"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "persistentvolumeclaims", "configmaps"]
  }

  rule {
    verbs      = ["*"]
    api_groups = [""]
    resources  = ["endpoints", "persistentvolumes", "pods"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
  }
}

resource "kubernetes_cluster_role_binding" "local_path_provisioner_bind" {
  metadata {
    name = "local-path-provisioner-bind"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "local-path-provisioner-service-account"
    namespace = "local-path-storage"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "local-path-provisioner-role"
  }
}

resource "kubernetes_deployment" "local_path_provisioner" {
  metadata {
    name      = "local-path-provisioner"
    namespace = "local-path-storage"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "local-path-provisioner"
      }
    }

    template {
      metadata {
        labels = {
          app = "local-path-provisioner"
        }
      }

      spec {
        volume {
          name = "config-volume"

          config_map {
            name = "local-path-config"
          }
        }

        container {
          name    = "local-path-provisioner"
          image   = "rancher/local-path-provisioner:v0.0.24"
          command = ["local-path-provisioner", "--debug", "start", "--config", "/etc/config/config.json"]

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config/"
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = "local-path-provisioner-service-account"
      }
    }
  }
}

resource "kubernetes_storage_class" "local_path" {
  metadata {
    name = "local-path"
  }

  storage_provisioner = "rancher.io/local-path"

  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_config_map" "local_path_config" {
  metadata {
    name      = "local-path-config"
    namespace = "local-path-storage"
  }

  data = {
    "config.json" = jsonencode({
        nodePathMap = [
          {
            node = "DEFAULT_PATH_FOR_NON_LISTED_NODES"
            paths = ["/opt/local-path-provisioner"]
          }
        ]
    })
    "helperPod.yaml" = yamlencode({
      "apiVersion" = "v1"
      "kind" = "Pod"
      "metadata" = {
        "name" = "helper-pod"
      }
      "spec" = {
        "containers" = [
          {
            "image" = "busybox"
            "imagePullPolicy" = "IfNotPresent"
            "name" = "helper-pod"
          },
        ]
      }
    })
    setup = <<-EOT
      #!/bin/sh
      set -eu
      mkdir -m 0777 -p \"$VOL_DIR\""
    EOT
    teardown = <<-EOT
      #!/bin/sh
      set -eu
      rm -rf \"$VOL_DIR\"
    EOT
  }
}