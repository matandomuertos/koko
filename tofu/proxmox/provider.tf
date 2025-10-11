# tofu init -backend-config=/bkp/tofu/backend.hcl
# tofu plan -var-file=/bkp/tofu/proxmox/terraform.tfvars

terraform {
  required_version = "~> 1.10"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.84"
    }
  }

  backend "s3" {
    key = "state/proxmox/opentofu.tfstate"
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint

  username = var.proxmox_username
  password = var.proxmox_password

  insecure = true

  ssh {
    agent       = false
    username    = var.proxmox_ssh_username
    private_key = file("~/.ssh/id_rsa")
  }
}
