data "proxmox_virtual_environment_nodes" "nodes" {}

resource "proxmox_virtual_environment_dns" "dns" {
  for_each = toset(data.proxmox_virtual_environment_nodes.nodes.names)

  node_name = each.value
  domain    = "koko"

  servers = [
    "1.1.1.1",
    "8.8.8.8",
  ]
}
