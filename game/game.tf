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

    enable_minecraft = var.minecraft.enable_minecraft
    minecraft_ram    = var.minecraft.ram
    minecraft_mods   = var.minecraft.mods
    minecraft_allow_flight = var.minecraft.allow_flight
    minecraft_allow_nether = var.minecraft.allow_nether
    minecraft_broadcast-console-to-ops = var.minecraft.broadcast-console-to-ops
    minecraft_broadcast-rcon-to-ops = var.minecraft.broadcast-rcon-to-ops
    minecraft_difficulty = var.minecraft.difficulty
    minecraft_enable-command-block = var.minecraft.enable-command-block
    minecraft_enable-jmx-monitoring = var.minecraft.enable-jmx-monitoring
    minecraft_enable-rcon = var.minecraft.enable-rcon
    minecraft_enable-status = var.minecraft.enable-status
    minecraft_enable-query = var.minecraft.enable-query
    minecraft_enforce-secure-profile = var.minecraft.enforce-secure-profile
    minecraft_enforce-whitelist = var.minecraft.enforce-whitelist
    minecraft_entity-broadcast-range-percentage = var.minecraft.entity-broadcast-range-percentage
    minecraft_force-gamemode = var.minecraft.force-gamemode
    minecraft_function-permission-level = var.minecraft.function-permission-level
    minecraft_gamemode = var.minecraft.gamemode
    minecraft_generate-structures = var.minecraft.generate-structures
    minecraft_generator-settings = var.minecraft.generator-settings
    minecraft_hardcore = var.minecraft.hardcore
    minecraft_hide-online-players = var.minecraft.hide-online-players
    minecraft_initial-disabled-packs = var.minecraft.initial-disabled-packs
    minecraft_initial-enabled-packs = var.minecraft.initial-enabled-packs
    minecraft_level-name = var.minecraft.level-name
    minecraft_level-seed = var.minecraft.level-seed
    minecraft_level-type = var.minecraft.level-type
    minecraft_max-chained-neighbor-updates = var.minecraft.max-chained-neighbor-updates
    minecraft_max-players = var.minecraft.max-players
    minecraft_max-tick-time = var.minecraft.max-tick-time
    minecraft_max-world-size = var.minecraft.max-world-size
    minecraft_motd = var.minecraft.motd
    minecraft_network-compression-threshold = var.minecraft.network-compression-threshold
    minecraft_online-mode = var.minecraft.online-mode
    minecraft_op-permission-level = var.minecraft.op-permission-level
    minecraft_player-idle-timeout = var.minecraft.player-idle-timeout
    minecraft_prevent-proxy-connections = var.minecraft.prevent-proxy-connections
    minecraft_previews-chat = var.minecraft.previews-chat
    minecraft_pvp = var.minecraft.pvp
    minecraft_query-port = var.minecraft.query-port
    minecraft_rate-limit = var.minecraft.rate-limit
    minecraft_rcon-password = var.minecraft.rcon-password
    minecraft_rcon-port = var.minecraft.rcon-port
    minecraft_resource-pack = var.minecraft.resource-pack
    minecraft_resource-pack-prompt = var.minecraft.resource-pack-prompt
    minecraft_resource-pack-sha1 = var.minecraft.resource-pack-sha1
    minecraft_require-resource-pack = var.minecraft.require-resource-pack
    minecraft_server-ip = var.minecraft.server-ip
    minecraft_server-port = var.minecraft.server-port
    minecraft_simulation-distance = var.minecraft.simulation-distance
    minecraft_snooper_enabled = var.minecraft.snooper_enabled
    minecraft_spawn-animals = var.minecraft.spawn-animals
    minecraft_spawn-monsters = var.minecraft.spawn-monsters
    minecraft_spawn-npcs = var.minecraft.spawn-npcs
    minecraft_spawn-protection = var.minecraft.spawn-protection
    minecraft_sync-chunk-writes = var.minecraft.sync-chunk-writes
    minecraft_use-native-transport = var.minecraft.use-native-transport
    minecraft_view-distance = var.minecraft.view-distance
    minecraft_white-list = var.minecraft.white-list
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