resource "kubernetes_deployment" "pihole" {
  metadata {
    name = "pihole"
    labels = {
      app = "pihole"
    }
    namespace = kubernetes_namespace.pihole.metadata[0].name
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "pihole"
      }
    }
    template {
      metadata {
        labels = {
          app = "pihole"
        }
      }
      spec {
        container {
          image = "pihole/pihole:latest"
          name  = "pihole"

          port {
            container_port = 80
            name           = "http"
            protocol       = "TCP"
          }
          port {
            container_port = 443
            name           = "https"
            protocol       = "TCP"
          }
          port {
            container_port = 53
            name           = "dns-udp"
            protocol       = "UDP"
          }
          port {
            container_port = 67
            name           = "dns67"
            protocol       = "UDP"
          }

          env {
            name  = "TZ"
            value = "America/Vancouver"
          }
          env {
            name  = "WEBPASSWORD"
            value_from {
              secret_key_ref {
                name = "pihole-secret-webpassword"
                key = "WEBPASSWORD"
              }
            }
          }
          env {
            name = "VIRTUAL_HOST"
            value = "pihole.inskip.me"
          }
          env {
            name  = "DNS1"
            value = "1.1.1.1"
          }
          env {
            name  = "DNS2"
            value = "1.0.0.1"
          }
          env {
            name  = "DNSMASQ_LISTENING"
            value = "all"
          }
          env {
            name = "PIHOLE_BASE"
            value = "/opt/pihole-volume"
          }

          resources {
            limits = {
              cpu    = "250m"
              memory = "896Mi"
            }
            requests  = {
              cpu    = "20m"
              memory = "512Mi"
            }
          }

          volume_mount {
            name = "pihole-volume"
            mount_path = "/opt/pihole-volume"
          }

          volume_mount {
            name = "regex"
            mount_path = "/etc/pihole/regex.list"
            sub_path = "regex.list"
          }
          volume_mount {
            name = "adlists"
            mount_path = "/etc/pihole/adlists.list"
            sub_path = "adlists.list"
          }
          volume_mount {
            name = "whitelist"
            mount_path = "/etc/pihole/whitelist.txt"
            sub_path = "whitelist.txt"
          }

          /*
          TODO: figure out probes
          liveness_probe {
            http_get {
              path = "/admin/index.php"
              port = 80
            }
            initial_delay_seconds = 180
            period_seconds = 15
          }

          readiness_probe {
            http_get {
              path = "/admin/index.php"
              port = 80
            }
            initial_delay_seconds = 60
            period_seconds = 15
          }
        */
        }

        container {
          image = "ghcr.io/tailscale/tailscale:latest"
          name  = "tailscale"

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }

          env {
            name = "TS_HOSTNAME"
            value = "pihole"
          }

          env {
            name = "TS_KUBE_SECRET"
            value = ""
          }

          env {
            name = "TS_STATE_DIR"
            value = "/tailscale"
          }

          env {
            name = "TS_USERPSACE"
            value = "false"
          }

          env {
            name  = "TS_AUTHKEY"
            value_from {
              secret_key_ref {
                name = "tailscale-auth"
                key = "TS_AUTHKEY"
              }
            }
          }
          
          resources {
            limits = {
              cpu    = "250m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "20m"
              memory = "64Mi"
            }
          }

        volume_mount {
            name = "tailscale-state-volume"
            mount_path = "/tailscale"
          }
        }

        volume {
          name = "pihole-volume"
          persistent_volume_claim {
            claim_name = "pihole-volume-claim"
          }
        }

        volume {
          name = "regex"
          config_map {
            name = "regex.list"
          }
        }
        volume {
          name = "adlists"
          config_map {
            name = "adlists.list"
          }
        } 
        volume {
          name = "whitelist"
          config_map {
            name = "whitelist.txt"
          }
        }

        volume {
          name = "tailscale-state-volume"
          persistent_volume_claim {
            claim_name = "tailscale-state-volume-claim"
          }
        } 
      }
    }
  }
}