variable "storage_size" {
  type = number
  validation {
    condition = var.storage_size >= 10
    error_message = "storage_size must be equal or higher than 10"
  }
}

variable "location" {
  type = string
}

variable "volume_format" {
  type = string
}

variable "hcloud_token" {
  type = string
  sensitive = true
}