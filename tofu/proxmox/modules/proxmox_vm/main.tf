locals {
  iso_datastore_mapping = {
    "koko-pve1" = "iso"
    "koko-pve2" = "iso2"
  }
  iso_datastore = lookup(local.iso_datastore_mapping, var.node_name, "iso")
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
    datastore_id = var.main_disk_datastore
    import_from  = var.import_cloud_image_enabled ? "${local.iso_datastore}:import/${var.cloud_image_name}" : null
    interface    = "scsi0"
    iothread     = false
    discard      = var.main_disk_discard
    size         = var.main_disk_size
    backup       = var.main_disk_backup
  }

  dynamic "disk" {
    for_each = var.additional_disks
    content {
      datastore_id = disk.value.datastore
      size         = disk.value.size
      interface    = disk.value.interface
      iothread     = disk.value.iothread
      discard      = disk.value.discard
      backup       = disk.value.backup
    }
  }

  keyboard_layout = var.keyboard_layout

  network_device {
    bridge = "vmbr0"
  }

  dynamic "usb" {
    for_each = var.usb_skyconnect_enabled ? [1] : []

    content {
      usb3    = false
      mapping = proxmox_virtual_environment_hardware_mapping_usb.usb[0].name
    }
  }

  dynamic "initialization" {
    for_each = var.import_cloud_image_enabled ? [1] : []

    content {
      datastore_id = var.main_disk_datastore

      ip_config {
        ipv4 {
          address = var.ip_address
          gateway = var.gateway
        }
      }

      user_account {
        username = var.username
        keys     = var.ssh_key
        password = var.user_password != "" ? var.user_password : null
      }

      dns {
        servers = var.dns_servers != "" ? var.dns_servers : null
      }
    }
  }
}

resource "proxmox_virtual_environment_hardware_mapping_usb" "usb" {
  count = var.usb_skyconnect_enabled ? 1 : 0

  name = "skyconnect-usb-device"

  map = [
    {
      comment = "SkyConnect USB Device"
      id      = "10c4:ea60"
      node    = var.node_name
    },
  ]
}
