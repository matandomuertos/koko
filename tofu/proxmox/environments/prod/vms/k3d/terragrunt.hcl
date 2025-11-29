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
  name          = "k3d1"
  username      = local.secrets_vars.locals.vm_username
  user_password = local.secrets_vars.locals.vm_password
  ssh_key       = local.secrets_vars.locals.vm_ssh_key

  node_name = local.env_vars.locals.node_name

  cpu_cores        = 3
  memory_dedicated = 16384
  memory_floating  = 24576
  ip_address       = "192.168.0.108/24"

  main_disk_size    = 60
  main_disk_discard = "ignore"

  tags = local.env_vars.locals.tags
}