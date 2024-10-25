/*resource "hcloud_network" "network" {
  name     = "network-17a07f9"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "subnet" {
    network_id = hcloud_network.network.id
    type = "cloud"
    network_zone = "us-west"
    ip_range = "10.0.1.0/24"
}*/