variable "proxmox_apiurl" {
  description = "This is the target Proxmox API endpoint"
  type        = string
  default     = "https://192.168.1.20:8006/api2/json"
}

variable "proxmox_host" {
  description = "Proxmox host to build VM on"
  type        = string
  default     = "proxmox"
}

variable "proxmox_ignoretls" {
  description = "Disable TLS verification while connecting"
  type        = string
  default     = "true"
}

variable "proxmox_token" {
  description = "API user token. Required, sensitive, or use environment variable TF_VAR_proxmox_token"
  type        = string
  default     = "18164336-2fa8-4e26-9324-fd645c270c25"
  sensitive   = true
}

variable "proxmox_user" {
  description = "This is the Proxmox API user. Use root@pam or custom. Will need PVEDatastoreUser, PVEVMAdmin, PVETemplateUser permissions"
  type        = string
  default     = "terraform@pve!proxmoxterraform"
  sensitive   = true
}