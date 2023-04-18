variable "hcloud_token" {
  type = string
  sensitive = true
}

variable "location" {
  type = string
}

variable "public_key" {
  type = string
}

variable "server_type" {
  type = string
}

variable "enable_terraria" {
  type = bool
}

variable "terraria_version" {
  type = number
  default = 1449
}

variable terraria_world_name {
  type = string
}

variable terraria_world_size {
  type = number
  default = 3
  validation {
    condition = var.terraria_world_size >= 1 && var.terraria_world_size <= 3
    error_message = "terraria_world_size must be either 1(small), 2(medium) or 3(large)."
  }
}

variable "terraria_port" {
  type = number
  default = 7777
}

variable "terraria_password" {
  type = string
  sensitive = true
}

variable "terraria_difficulty" {
  type = number
  default = 1
  validation {
    condition = var.terraria_difficulty >= 0 && var.terraria_difficulty <= 3
    error_message = "terraria_difiicultry must be either 0(normal), 1(expert), 2(master) or 3(journey)"
  }
}

variable "terraria_language" {
  type = string
  default = "en-US"
  validation {
    condition = contains(["en-US", "de-DE", "it-IT", "fr-FR", "es-ES", "ru-RU", "zh-Hans", "pt-BR", "pl-PL"], var.terraria_language)
    error_message = "terraria_language must be one of the following values: en-US, de-DE, it-IT, fr-FR, es-ES, ru-RU, zh-Hans, pt-BR, pl-PL"
  }
}

variable "enable_valheim" {
  type = bool
}

variable "admin_id" {
  type    = string
  default = ""
}

variable "valheim_server_name" {
  type    = string
}

variable "valheim_world_name" {
  type    = string
}

variable "valheim_port" {
  type    = number
  default = 2456
}

variable "valheim_password" {
  type      = string
  sensitive = true
  validation {
    condition = length(var.valheim_password) >= 5
    error_message = "valheim_password must be at least 5 characters long"
  }
}

variable "valheim_public" {
  type    = number
  default = 1
  validation {
    condition = var.valheim_public == 0 || var.valheim_public == 1
    error_message = "valheim_public must be either 0(private) or 1(public)"
  }
}

variable "minecraft" {
  type = object({
    enable_minecraft = bool
    allow_flight = bool
    allow_nether = bool
    broadcast-console-to-ops = bool
    broadcast-rcon-to-ops = bool
    difficulty = string
    enable-command-block = bool
    enable-jmx-monitoring = bool
    enable-rcon = bool
    enable-status = bool
    enable-query = bool
    enforce-secure-profile = bool
    enforce-whitelist = bool
    entity-broadcast-range-percentage = number
    force-gamemode = bool
    function-permission-level = number
    gamemode = string
    generate-structures = bool
    generator-settings = string
    hardcore = bool
    hide-online-players = bool
    initial-disabled-packs = string
    initial-enabled-packs = string
    level-name = string
    level-seed = string
    level-type = string
    max-chained-neighbor-updates = number
    max-players = number
    max-tick-time = number
    max-world-size = number
    mods = list(string)
    motd = string
    network-compression-threshold = number
    online-mode = bool
    op-permission-level = number
    player-idle-timeout = number
    prevent-proxy-connections = bool
    previews-chat = bool
    pvp = bool
    query-port = number #query.port
    ram = number
    rate-limit = number
    rcon-password = string #rcon.password
    rcon-port = number #rcon.port
    resource-pack = string
    resource-pack-prompt = string
    resource-pack-sha1 = string
    require-resource-pack = bool
    server-ip = string 
    server-port = number
    simulation-distance = number
    snooper_enabled = bool
    spawn-animals = bool
    spawn-monsters = bool
    spawn-npcs = bool
    spawn-protection = number
    sync-chunk-writes = bool
    use-native-transport = bool
    view-distance = number
    white-list = bool
  })
  default = { 
    enable_minecraft = false
    allow_flight = false
    allow_nether = true
    broadcast-console-to-ops = true
    broadcast-rcon-to-ops = true
    difficulty = "easy"
    enable-command-block = false
    enable-jmx-monitoring = false
    enable-rcon = false
    enable-status = true
    enable-query = false
    enforce-secure-profile = true
    enforce-whitelist = false
    entity-broadcast-range-percentage = 100
    force-gamemode = false
    function-permission-level = 2
    gamemode = "survival"
    generate-structures = true
    generator-settings = "{}"
    hardcore = false
    hide-online-players = false
    initial-disabled-packs = ""
    initial-enabled-packs = "vanilla"
    level-name = "world"
    level-seed = ""
    level-type = "minecraft:normal"
    max-chained-neighbor-updates = 1000000
    max-players = 20
    max-tick-time = 60000
    max-world-size = 29999984
    mods = []
    motd = "A Minecraft Server"
    network-compression-threshold = 256
    online-mode = true
    op-permission-level = 4
    player-idle-timeout = 0
    prevent-proxy-connections = false
    previews-chat = false
    pvp = true
    query-port = 25565 #query.port
    ram = 1
    rate-limit = 0
    rcon-password = "" #rcon.password
    rcon-port = 25575 #rcon.port
    resource-pack = ""
    resource-pack-prompt = ""
    resource-pack-sha1 = ""
    require-resource-pack = false
    server-ip = "" 
    server-port = 25565
    simulation-distance = 10
    snooper_enabled = true
    spawn-animals = true
    spawn-monsters = true
    spawn-npcs = true
    spawn-protection = 16
    sync-chunk-writes = true
    use-native-transport = true
    view-distance = 10
    white-list = false
  }
}