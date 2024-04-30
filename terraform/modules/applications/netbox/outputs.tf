output "vm_ip_addresses" {
	value = {
		for vm in proxmox_vm_qemu.qemu_vm:
		vm.name => vm.default_ipv4_address
	}
}
