output "dhcpip" {
	value = proxmox_vm_qemu.qemu_vm[0].default_ipv4_address
}