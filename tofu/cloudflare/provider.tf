terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11"
    }
  }

  backend "local" {
    path = "/bkp/tofu/cloudflare/terraform.tfstate"
  }
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}
