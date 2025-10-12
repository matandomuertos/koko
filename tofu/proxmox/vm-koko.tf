module "koko" {
  source = "../modules/proxmox_vm"

  name          = "koko"
  username      = var.vm_username
  user_password = var.vm_password
  ssh_key       = var.vm_ssh_key
  ip_address    = "192.168.0.102/24"

  main_disk_size    = 100
  main_disk_discard = "ignore"

  raw_disks = [
    {
      interface         = "scsi"
      path_in_datastore = "/dev/hdd-vg/koko-hdd-lv"
      iothread          = true
    }
  ]
}
