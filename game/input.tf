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