include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = "${get_terragrunt_dir()}/../../../_env/vm.hcl"
}

locals {
  secrets_vars = read_terragrunt_config("/bkp/tofu/proxmox/tg.hcl")
  env_vars     = read_terragrunt_config("../../env.hcl")
}

inputs = {
  name          = "koko"
  username      = local.secrets_vars.locals.vm_username
  user_password = local.secrets_vars.locals.vm_password
  ssh_key       = local.secrets_vars.locals.vm_ssh_key

  cpu_cores        = 6
  cpu_type         = "host"
  memory_dedicated = 16384
  memory_floating  = 24576
  ip_address       = "192.168.0.102/24"

  main_disk_size    = 40
  main_disk_discard = "ignore"

  additional_disks = [
    {
      size      = 60
      datastore = "data"
      interface = "scsi1"
      iothread  = false
      discard   = "ignore"
      backup    = false
    },
    {
      size      = 400
      datastore = "data-hdd"
      interface = "scsi2"
      iothread  = false
      discard   = "ignore"
      backup    = true
    },
    {
      size      = 250
      datastore = "data-hdd"
      interface = "scsi3"
      iothread  = false
      discard   = "ignore"
      backup    = true
    }
  ]

  tags = local.env_vars.locals.tags
}