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
