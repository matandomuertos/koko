# tofu apply -var-file=/bkp/tofu/cloudflare/terraform.tfvars

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11"
    }
  }

  backend "s3" {
    bucket                      = "tf-bucket"
    region                      = "EEUR"
    key                         = "state/${path_relative_to_include()}/opentofu.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true

    endpoint = {
      s3 = "https://${cloudflare_account_id}.r2.cloudflarestorage.com"
    }
  }
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}
