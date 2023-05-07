resource "kubernetes_ingress" "pihole_ingress" {
  metadata {
    name      = "pihole"
    namespace = "pihole"
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = "pihole-tcp"
            service_port = 80
          }
          path = "/admin"
        }
      }
    }
  }
}