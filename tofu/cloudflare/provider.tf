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
    bucket                      = "tf-bucket"
    region                      = "auto"
    key                         = "state/cloudflare/opentofu.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}
