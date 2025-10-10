resource "proxmox_virtual_environment_cluster_options" "options" {
  language       = "en"
  keyboard       = "pl"
  max_workers    = 5
  migration_cidr = "10.0.0.0/8"
  migration_type = "secure"
}
