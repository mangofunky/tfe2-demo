terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mangofunky-tf3

    workspaces {
      name = "tfe2-demo"
    }
  }
}
