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
