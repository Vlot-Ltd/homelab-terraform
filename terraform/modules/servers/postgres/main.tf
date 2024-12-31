locals {
    vm_name = "postgres"
    vm_ipaddress = "192.168.1.9"
}

module "postgres" {
    source = "../../infrastructure/proxmox-vm"
    vm_name = local.vm_name
    vm_ipaddress = local.vm_ipaddress
}