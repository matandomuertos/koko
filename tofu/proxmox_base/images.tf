## This file should be refactored to a module in the future

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "iso"
  node_name    = "koko-pve1"
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name    = "ubuntu2204-amd64.qcow2"
}

## Duplicate image in node koko-pve2 for faster VM creation
resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image_pve2" {
  content_type = "import"
  datastore_id = "iso2"
  node_name    = "koko-pve2"
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name    = "ubuntu2204-amd64.qcow2"
}

resource "proxmox_virtual_environment_download_file" "proxmox_backup_server" {
  content_type = "iso"
  datastore_id = "iso2"
  node_name    = "koko-pve2"
  url          = "https://enterprise.proxmox.com/iso/proxmox-backup-server_4.0-1.iso"
  file_name    = "pbs-4.0-1.iso"
}
