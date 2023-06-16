terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "kittywitch"

    workspaces {
      name = "infrastructure-tf"
    }
  }
}
