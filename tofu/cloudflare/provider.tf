# tofu init -backend-config=/bkp/tofu/backend.hcl
# tofu plan -var-file=/bkp/tofu/cloudflare/terraform.tfvars

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11"
    }
  }

  backend "s3" {
    key = "state/cloudflare/opentofu.tfstate"
  }
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}
