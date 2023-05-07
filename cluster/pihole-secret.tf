variable "pihole_secret_WEBPASSWORD" {
  description = "web ui password"
}

resource "kubernetes_secret" "pihole-webpassword" {
  metadata {
    name = "pihole-secret-webpassword"
    namespace = "pihole"
  }
  data = {
    WEBPASSWORD = var.pihole_secret_WEBPASSWORD
  }
  type = "Opaque"
}