data "proxmox_virtual_environment_nodes" "available_nodes" {}

resource "proxmox_virtual_environment_time" "tz" {
  for_each = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)

  node_name = each.value
  time_zone = "Europe/Warsaw"
}
