resource "proxmox_vm_qemu" "qemu_vm" {
  count       = 1
  name        = "testvm${count.index + 1}"
  target_node = "proxmox"
  clone       = "tpl-ubuntu-22-04"
  os_type     = "cloud-init"
  cpu         = "kvm64"
  agent       = 1
  cores       = 2
  sockets     = 1
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  disk {
    slot     = 0
    size     = "50G"
    type     = "scsi"
    storage  = "vmosstorage"
    format   = "raw"
  }
  network {
    model     = "virtio"
    bridge    = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.1.3${count.index + 1}/24,gw=192.168.1.254"
  sshkeys   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILw4mdBvAc7uevh7LvM9tJ+wlRW1h9rCChdyzHIjYkHe"
}