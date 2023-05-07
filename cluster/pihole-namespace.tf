resource "kubernetes_namespace" "pihole" {
  metadata {
    annotations = {
      name = "pihole"
    }

    labels = {
      app = "pihole"
    }

    name = "pihole"
  }
}