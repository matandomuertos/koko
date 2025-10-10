data "local_file" "ssh_public_key" {
  filename = var.ssh_public_key_file
}

resource "proxmox_virtual_environment_vm" "vm" {
  name            = var.name
  node_name       = var.node_name
  stop_on_destroy = true
  tags            = var.tags
  description     = var.description

  agent {
    enabled = var.qemu_agent
    timeout = var.qemu_agent_timeout
  }

  operating_system {
    type = var.os_type
  }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_dedicated
    floating  = var.memory_floating
  }

  disk {
    datastore_id = var.disk_datastore
    import_from  = "iso:import/${var.cloud_image_name}"
    interface    = "scsi0"
    iothread     = false
    discard      = var.main_disk_discard
    size         = var.main_disk_size
  }

  dynamic "disk" {
    for_each = var.additional_disks
    content {
      datastore_id = disk.value.datastore
      size         = disk.value.size
      interface    = disk.value.interface
      iothread     = disk.value.iothread
      discard      = disk.value.discard
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    datastore_id = var.disk_datastore

    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      username = var.username
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
      password = var.user_password != "" ? var.user_password : null
    }

    dns {
      servers = var.dns_servers != "" ? var.dns_servers : null
    }
  }
}
