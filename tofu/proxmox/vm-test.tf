module "test_ubuntu_vm" {
  source = "../modules/proxmox_vm"

  name                = "test-ubuntu"
  ssh_public_key_file = "${path.module}/files/nahuel.pub"
  ip_address          = "192.168.0.151/24"

  main_disk_size = 40

  additional_disks = [
    {
      size      = 10
      datastore = "data"
      interface = "scsi1"
      iothread  = false
      discard   = "on"
    }
  ]
}
