provider "proxmox" {
  endpoint = "${proxmox_endpoint}"

  username = "${proxmox_username}"
  password = "${proxmox_password}"

  insecure = true

  ssh {
    agent       = false
    username    = "${proxmox_ssh_username}"
    private_key = file("~/.ssh/id_rsa")
  }
}
