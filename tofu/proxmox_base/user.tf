resource "proxmox_virtual_environment_user" "nahuel" {
  acl {
    path      = "/"
    propagate = true
    role_id   = "Administrator"
  }

  comment = "Managed by Terraform"
  user_id = "nahuel@pam"
}
