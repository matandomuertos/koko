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

variable "vm_ssh_key" {
  description = "VM SSH key"
  type        = list(string)
}

variable "vm_username" {
  description = "VM username"
  type        = string
}

variable "vm_password" {
  description = "VM user password"
  type        = string
}
