include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = "${get_terragrunt_dir()}/../../../../_env/vm.hcl"
}

locals {
  secrets_vars = read_terragrunt_config("/bkp/tofu/proxmox/tg.hcl")
  env_vars     = read_terragrunt_config("../../../env.hcl")
}

inputs = {
  name          = "k3s2"
  username      = local.secrets_vars.locals.vm_username
  user_password = local.secrets_vars.locals.vm_password
  ssh_key       = local.secrets_vars.locals.vm_ssh_key

  node_name = local.env_vars.locals.node_name

  # started = false

  cpu_cores        = 2
  memory_dedicated = 8192
  memory_floating  = 16384
  ip_address       = "192.168.0.120/24"

  main_disk_datastore = "data2"
  main_disk_size      = 20
  main_disk_discard   = "ignore"
  main_disk_backup    = false

  tags = local.env_vars.locals.tags
}