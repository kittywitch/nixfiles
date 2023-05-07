resource "kubernetes_config_map" "pihole_regex_list" {
  metadata {
    name      = "regex.list"
    namespace = kubernetes_namespace.pihole.metadata[0].name
  }

  data = {
    "regex.list" = <<EOF
    EOF
  }
}

resource "kubernetes_config_map" "pihole_adlists_list" {
  metadata {
    name      = "adlists.list"
    namespace = kubernetes_namespace.pihole.metadata[0].name
  }

  data = {
    "adlists.list" = <<EOF
https://raw.githubusercontent.com/Perflyst/PiHoleBlocklist/master/android-tracking.txt
https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt
https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-blocklist.txt
    EOF
  }
}

resource "kubernetes_config_map" "pihole_whitelist_list" {
  metadata {
    name      = "whitelist.txt"
    namespace = kubernetes_namespace.pihole.metadata[0].name
  }

  data = {
    "adlists.list" = <<EOF
bbc.co.uk
    EOF
  }
}