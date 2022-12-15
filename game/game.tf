terraform {
  backend "local" {
  }
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.15"
}

data "hcloud_datacenters" "ds" {
}

data "terraform_remote_state" "storage" {
  backend = "local"

  config = {
    path = "${path.module}/../storage/terraform.tfstate"
  }
}

resource "hcloud_ssh_key" "default" {
  name       = "hetzner_key"
  public_key = file(var.public_key)
}

resource "hcloud_server" "main" {
  name          = "game-server"
  image         = "ubuntu-20.04"
  server_type   = var.server_type
  location      = var.location
  ssh_keys      = [hcloud_ssh_key.default.id]

  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.main.id
    ipv6_enabled = false
  }

  user_data = templatefile("${path.module}\\game_config.yaml", {
    ip_address            = hcloud_primary_ip.main.ip_address
    mount_name            = data.terraform_remote_state.storage.outputs["volume_name"]
    mount_device          = data.terraform_remote_state.storage.outputs["volume_device"]
    mount_format          = data.terraform_remote_state.storage.outputs["volume_format"]
    
    enable_terraria       = var.enable_terraria
    terraria_world_name   = var.terraria_world_name
    terraria_world_size   = tostring(var.terraria_world_size)
    terraria_port         = tostring(var.terraria_port)
    terraria_version      = tostring(var.terraria_version)
    terraria_password     = var.terraria_password
    terraria_difficulty   = tostring(var.terraria_difficulty)
    terraria_language     = var.terraria_language

    enable_valheim        = var.enable_valheim
    admin_id              = var.admin_id
    valheim_server_name   = var.valheim_server_name
    valheim_world_name    = var.valheim_world_name
    valheim_port          = tostring(var.valheim_port)
    valheim_password      = var.valheim_password
    valheim_public        = tostring(var.valheim_public)
  })
}

resource "hcloud_primary_ip" "main" {
  name          = "PublicIP"
  type          = "ipv4"
  assignee_type = "server"
  datacenter    = one([ for item in data.hcloud_datacenters.ds.datacenters : item.name if can(regex(var.location, item.location.name)) ])
  auto_delete   = false
}

resource "hcloud_volume_attachment" "main" {
  volume_id = data.terraform_remote_state.storage.outputs["volume_id"]
  server_id = hcloud_server.main.id
  automount = true
}