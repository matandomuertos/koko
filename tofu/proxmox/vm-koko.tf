module "koko" {
  source = "../modules/proxmox_vm"

  name          = "koko"
  username      = var.vm_username
  user_password = var.vm_password
  ssh_key       = var.vm_ssh_key

  cpu_cores        = 6
  memory_dedicated = 16384
  memory_floating  = 24576
  ip_address       = "192.168.0.102/24"

  main_disk_size    = 100
  main_disk_discard = "ignore"

  additional_disks = [
    {
      size      = 400
      datastore = "data-hdd"
      interface = "scsi1"
      iothread  = false
      discard   = "ignore"
      backup    = false
    }
  ]
}
