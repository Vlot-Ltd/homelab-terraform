provider "proxmox" {
  pm_api_url = var.proxmox_apiurl
  pm_api_token_id = var.proxmox_user
  pm_api_token_secret = var.proxmox_token
  pm_tls_insecure     = var.proxmox_ignoretls
}