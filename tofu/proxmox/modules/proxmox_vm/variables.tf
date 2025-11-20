variable "name" {
  description = "VM name"
  type        = string
}

variable "node_name" {
  description = "Proxmox node to create the VM on"
  type        = string
  default     = "koko-pve1"
}

variable "vm_id" {
  description = "Optional VM ID. Leave empty to auto-generate"
  type        = number
  default     = null
}

variable "started" {
  description = "Whether the VM should be started after creation"
  type        = bool
  default     = true
}

variable "os_type" {
  description = "Operating System type"
  type        = string
  default     = "l26"
}

variable "keyboard_layout" {
  description = "Keyboard Layout"
  type        = string
  default     = "pl"
}

variable "qemu_agent" {
  description = "Whether to enable the QEMU agent"
  type        = bool
  default     = false
}

variable "qemu_agent_timeout" {
  description = "The maximum amount of time to wait for data from the QEMU agent to become available"
  type        = string
  default     = "15m"
}

variable "main_disk_datastore" {
  description = "Datastore for VM disks"
  type        = string
  default     = "data"
}

variable "cloud_image_name" {
  description = "Name of the pre-downloaded cloud image in Proxmox datastore"
  type        = string
  default     = "ubuntu2204-amd64.qcow2"
}

variable "import_cloud_image_enabled" {
  description = "Whether to import the cloud image to the main disk"
  type        = bool
  default     = true
}

variable "main_disk_size" {
  description = "Size of the main VM disk in GB"
  type        = number
  default     = 20
}

variable "main_disk_discard" {
  description = "Enable discard on the main disk (on/off)"
  type        = string
  default     = "on"
}

variable "main_disk_backup" {
  description = "Enable backup on the main disk"
  type        = bool
  default     = true
}

variable "ssh_key" {
  description = "Path to the public SSH key to use"
  type        = list(string)
}

variable "gateway" {
  description = "IPv4 gateway"
  type        = string
  default     = "192.168.0.1"
}

variable "ip_address" {
  description = "Static IPv4 address for cloud-init"
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "List of DNS servers for the VM"
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "dns_domain" {
  description = "DNS domain for the VM"
  type        = string
  default     = "koko"
}

variable "username" {
  description = "Username for cloud-init"
  type        = string
}

variable "user_password" {
  description = "Optional password for cloud-init user"
  type        = string
  default     = ""
}

variable "tags" {
  description = "List of tags for the VM"
  type        = list(string)
  default     = []
}

variable "description" {
  description = "VM description"
  type        = string
  default     = ""
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "cpu_type" {
  description = "CPU type"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory_dedicated" {
  description = "Dedicated RAM in MB"
  type        = number
  default     = 2048
}

variable "memory_floating" {
  description = "Floating RAM in MB (ballooning)"
  type        = number
  default     = 2048
}

variable "additional_disks" {
  description = "List of additional disks (each disk is an object with keys: size, datastore, interface, iothread, discard)"
  type = list(object({
    size      = number
    datastore = string
    interface = string
    iothread  = bool
    discard   = string
    backup    = bool
  }))
  default = []
}

variable "usb_skyconnect_enabled" {
  description = "Whether to enable USB SkyConnect device"
  type        = bool
  default     = false
}
