# export PROXMOX_VE_PASSWORD=123

terraform {
  required_version = "~> 1.10"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.84"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "proxmox" {
  endpoint = "https://192.168.0.100:8006/"

  username = "root@pam"

  insecure = true

  ssh {
    agent       = false
    username    = "nahuel"
    private_key = file("~/.ssh/id_rsa")
  }
}
