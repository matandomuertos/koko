# tofu/cloudflare/buckets.tf
resource "cloudflare_r2_bucket" "tf_bucket" {
  account_id    = var.cloudflare_account_id
  name          = "tf-bucket"
  location      = "eeur"
  storage_class = "Standard"
}

# tofu/cloudflare/dns.tf
resource "cloudflare_zone" "wyppu" {
  account = {
    id = var.cloudflare_account_id
  }
  name = var.zone_name
  type = "full"
}

resource "cloudflare_dns_record" "main_domain" {
  zone_id = cloudflare_zone.wyppu.id
  name    = var.zone_name
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_ip
  proxied = false
}

resource "cloudflare_dns_record" "all_private" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "*"
  ttl     = 1 #auto
  type    = "A"
  content = var.koko_ip
  proxied = false
}

resource "cloudflare_dns_record" "cname" {
  zone_id = cloudflare_zone.wyppu.id
  name    = "www"
  ttl     = 1 #auto
  type    = "CNAME"
  content = var.zone_name
  proxied = false
}

# tofu/cloudflare/outputs.tf
output "cloudflare_name_servers" {
  value = cloudflare_zone.wyppu.name_servers
}

# tofu/cloudflare/provider.tf
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

# tofu/cloudflare/variables.tf
variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID"
  sensitive   = true
}

variable "cloudflare_email" {
  type        = string
  description = "Your Cloudflare email"
  sensitive   = true
}

variable "cloudflare_api_token" {
  type        = string
  description = "Your Cloudflare API token"
  sensitive   = true
}

variable "zone_name" {
  type        = string
  description = "The name of the DNS zone"
}

variable "koko_ip" {
  type        = string
  description = "The IP address for the Koko service"
  default     = "192.168.0.39"
}

# tofu/ovh/domain.tf
data "terraform_remote_state" "cloudflare" {
  backend = "s3"

  config = {
    bucket                      = var.cloudflare_r2_bucket
    region                      = "auto"
    key                         = "state/cloudflare/opentofu.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true

    endpoints = {
      s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
    }
    access_key = var.cloudflare_r2_access_key
    secret_key = var.cloudflare_r2_secret_key
  }
}

resource "ovh_domain_name" "wyppu" {
  domain_name = var.domain_name

  target_spec = {
    dns_configuration = {
      name_server = data.terraform_remote_state.cloudflare.outputs.cloudflare_name_servers
    }
  }
}

# tofu/ovh/provider.tf
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
    key = "state/ovh/opentofu.tfstate"
  }
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.application_key
  application_secret = var.application_secret
  consumer_key       = var.consumer_key
}

# tofu/ovh/variables.tf
variable "application_key" {
  description = "OVH application key"
  type        = string
  sensitive   = true
}

variable "application_secret" {
  description = "OVH application secret"
  type        = string
  sensitive   = true
}

variable "consumer_key" {
  description = "OVH consumer key"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  type        = string
  description = "The name of the domain"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID"
  sensitive   = true
}

variable "cloudflare_r2_bucket" {
  type        = string
  description = "Cloudflare R2 Bucket Name"
}

variable "cloudflare_r2_access_key" {
  type        = string
  description = "Cloudflare R2 Access Key"
  sensitive   = true
}

variable "cloudflare_r2_secret_key" {
  type        = string
  description = "Cloudflare R2 Secret Key"
  sensitive   = true
}