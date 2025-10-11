data "terraform_remote_state" "cloudflare" {
  backend = "s3"

  config = {
    bucket                      = "tf-bucket"
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
