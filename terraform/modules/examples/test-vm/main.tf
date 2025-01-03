resource "proxmox_vm_qemu" "qemu_vm" {
  count       = 1
  name        = "test"
  target_node = "proxmox"
  clone       = "tpl-ubuntu-22-04"
  os_type     = "cloud-init"
  cpu         = "kvm64"
  agent       = 1
  cores       = 2
  sockets     = 1
  memory      = 4196
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  disk {
    slot     = 0
    size     = "150G"
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

  ipconfig0 = "ip=192.168.1.7,gw=192.168.1.254"
  sshkeys   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILw4mdBvAc7uevh7LvM9tJ+wlRW1h9rCChdyzHIjYkHe"

connection {
    type     = "ssh"
    user     = "proxmox"
    password = "proxmox"
    host     = self.default_ipv4_address
  }
  provisioner "remote-exec" {
    inline = [
      "curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io",
      "chmod +x bootstrap-salt.sh",
      "sudo ./bootstrap-salt.sh -P onedir"
    ]
  }

  provisioner "file" {
    source      = "files/salt-minion"
    destination = "/tmp/salt-minion"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/salt-minion /etc/salt/minion",
      "sudo chmod 644 /etc/salt/minion",
      "sudo chown root:root /etc/salt/minion",
      "sudo systemctl restart salt-minion.service",
      "sudo systemctl enable salt-minion.service"
    ]
  }

  provisioner "local-exec" {
    command = "inspec exec https://github.com/dev-sec/linux-baseline --target=ssh://${self.default_ipv4_address} --user=proxmox --password=proxmox --reporter=cli json:inspec_logs/${self.name}_$(date +%Y%m%d_%H%M%S).json"
    on_failure = continue
  }
}