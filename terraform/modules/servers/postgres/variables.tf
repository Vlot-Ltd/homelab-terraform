variable "proxmox_token" {
  description = "API user token. Required, sensitive, or use environment variable TF_VAR_proxmox_token"
  type        = string
  sensitive   = true
}

variable "proxmox_user" {
  description = "This is the Proxmox API user. Use root@pam or custom. Will need PVEDatastoreUser, PVEVMAdmin, PVETemplateUser permissions"
  type        = string
  sensitive   = true
}