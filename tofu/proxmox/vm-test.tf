module "test_ubuntu_vm" {
  source = "../modules/proxmox_vm"

  name          = "test-ubuntu"
  username      = var.vm_username
  user_password = var.vm_password
  ssh_key       = var.vm_ssh_key
  ip_address    = "192.168.0.151/24"

  main_disk_size = 40

  additional_disks = [
    {
      size      = 10
      datastore = "data"
      interface = "scsi1"
      iothread  = false
      discard   = "on"
      backup    = false
    }
  ]
}
