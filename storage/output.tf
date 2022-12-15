output "volume_id" {
    value = hcloud_volume.main.id
}

output "volume_name" {
    value = hcloud_volume.main.name
}

output "volume_device" {
    value = hcloud_volume.main.linux_device
}

output "volume_format" {
    value = hcloud_volume.main.format
}