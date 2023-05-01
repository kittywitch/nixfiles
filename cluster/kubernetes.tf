variable "client_certificate" {
    type = string
}

variable "client_key" {
    type = string
}

variable "cluster_ca_certificate" {
    type = string
}


provider "kubernetes" {
    host = "https://ran.gensokyo.zone:6443"
    client_certificate = var.client_certificate
    client_key = var.client_key
    cluster_ca_certificate = var.cluster_ca_certificate
}