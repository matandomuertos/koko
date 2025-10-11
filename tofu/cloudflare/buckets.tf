resource "cloudflare_r2_bucket" "tf_bucket" {
  account_id    = var.cloudflare_account_id
  name          = "tf-bucket"
  location      = "eeur"
  storage_class = "Standard"
}
