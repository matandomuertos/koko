variable "proxmox_endpoint" {
  description = "Proxmox Endpoint"
  type        = string
}

variable "proxmox_username" {
  description = "Proxmox UI username"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox UI password"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_username" {
  description = "Proxmox ssh username"
  type        = string
}
