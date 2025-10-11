# tofu init -backend-config=/bkp/tofu/backend.hcl
# tofu plan -var-file=/bkp/tofu/ovh/terraform.tfvars

terraform {
  required_version = "~> 1.10"
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.8"
    }
  }

  backend "s3" {
    bucket                      = "tf-bucket"
    region                      = "auto"
    key                         = "state/ovh/opentofu.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.application_key
  application_secret = var.application_secret
  consumer_key       = var.consumer_key
}
