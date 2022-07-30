terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mangofunky-terraform"

    workspaces {
      name = "tfe-poc-demo"
    }
  }
}