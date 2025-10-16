terraform_version_constraint  = ">= 1.10"
terragrunt_version_constraint = ">= 0.91"

locals {
  secrets_vars = read_terragrunt_config("/bkp/tofu/proxmox/tg.hcl")
  backend_vars = read_terragrunt_config("/bkp/tofu/tg-backend.hcl")

  bucket_key_path = "terragrunt/koko/proxmox/${path_relative_to_include()}/opentofu.tfstate"

  proxmox_provider_version = local.env_vars.locals.proxmox_provider_version
}

# Generate an Proxmox provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile("provider.tf.tpl", {
    proxmox_endpoint     = local.secrets_vars.locals.proxmox_endpoint
    proxmox_username     = local.secrets_vars.locals.proxmox_endpoint
    proxmox_password     = local.secrets_vars.locals.proxmox_password
    proxmox_ssh_username = local.secrets_vars.locals.proxmox_ssh_username
  })
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
generate "backend.tf" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile("backend.tf.tpl", {
    bucket      = local.bucket_key_path.locals.bucket
    key         = local.bucket_key_path
    access_key  = local.bucket_key_path.locals.access_key
    secret_key  = local.bucket_key_path.locals.secret_key
    s3_endpoint = local.bucket_key_path.locals.s3_endpoint
  })
}

# Configure Proxmox provider
generate "versions" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        proxmox = {
          source  = "bpg/proxmox"
          version = "${local.proxmox_provider_version}"
        }
      }
    }
EOF
}