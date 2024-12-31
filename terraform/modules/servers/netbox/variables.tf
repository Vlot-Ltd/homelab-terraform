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
  default     = "8b94662d-6552-49a2-aa75-494fd414605b"
  sensitive   = true
}

variable "proxmox_user" {
  description = "This is the Proxmox API user. Use root@pam or custom. Will need PVEDatastoreUser, PVEVMAdmin, PVETemplateUser permissions"
  type        = string
  default     = "terraform-prov@pve!terraform"
  sensitive   = true
}