terraform {
  cloud {
    organization = "vlotltd"

    workspaces {
      name = "homelab"
    }
  }
}
