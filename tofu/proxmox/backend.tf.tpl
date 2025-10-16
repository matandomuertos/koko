terraform {
  backend "s3" {
    bucket                      = "${bucket}"
    key                         = "${key}"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true

    access_key = "${access_key}"
    secret_key = "${secret_key}"

    endpoints = {
      s3 = "${s3_endpoint}"
    }
  }
}