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
  name          = "koko-dev"
  username      = local.secrets_vars.locals.vm_username
  user_password = local.secrets_vars.locals.vm_password
  ssh_key       = local.secrets_vars.locals.vm_ssh_key

  node_name = local.env_vars.locals.node_name

  cpu_cores        = 2
  cpu_type         = "host"
  memory_dedicated = 8192
  memory_floating  = 12288
  ip_address       = "192.168.0.104/24"

  main_disk_datastore = "data2"
  main_disk_size      = 40
  main_disk_discard   = "ignore"
  main_disk_backup    = false

  additional_disks = [
    {
      size      = 100
      datastore = "data-hdd2"
      interface = "scsi1"
      iothread  = false
      discard   = "ignore"
      backup    = false
    }
  ]

  tags = local.env_vars.locals.tags
}