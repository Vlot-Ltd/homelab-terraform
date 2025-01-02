
module "postgres" {
  source = "./modules/servers/postgres"

  proxmox_token = var.proxmox_token
  proxmox_user  = var.proxmox_user

}