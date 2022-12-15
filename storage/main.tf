terraform {
  backend "local" {
  }

  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}

resource "hcloud_volume" "main" {
  name              = "game-volume"
  size              = var.storage_size
  location          = var.location
  format            = var.volume_format
}