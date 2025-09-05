variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "cloudflare_email" {
  type        = string
  description = "Your Cloudflare email"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Your Cloudflare API token"
}

variable "zone_name" {
  type        = string
  description = "The name of the DNS zone"
}
