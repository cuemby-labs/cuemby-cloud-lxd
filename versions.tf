terraform {
  required_version = ">= 1.0"
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
      version = "2.5.0"
    }
  }
}
