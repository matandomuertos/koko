variable "application_key" {
  description = "OVH application key"
  type        = string
}

variable "application_secret" {
  description = "OVH application secret"
  type        = string
}

variable "consumer_key" {
  description = "OVH consumer key"
  type        = string
}

variable "domain_name" {
  type        = string
  description = "The name of the domain"
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "cloudflare_r2_access_key" {
  type        = string
  description = "Cloudflare R2 Access Key"
}

variable "cloudflare_r2_secret_key" {
  type        = string
  description = "Cloudflare R2 Secret Key"
}
