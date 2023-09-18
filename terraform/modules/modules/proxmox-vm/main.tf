resource "proxmox_vm_qemu" "qemu_vm" {
  os_type     = "cloud-init"
  cpu         = "kvm64"
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  name          = var.vm_name
  target_node   = var.proxmox_host
  clone         = var.vm_templatename
  full_clone    = var.vm_fullclone
  clone_wait    = var.vm_clonewait
  boot          = var.vm_bootorder
  agent         = var.vm_qemuagent
  sockets       = var.vm_sockets
  cores         = var.vm_cores
  memory        = var.vm_memory
  desc          = var.vm_description
  nameserver    = var.vm_nameserver
  searchdomain  = var.vm_searchdomain
  dynamic "network" {
    for_each = var.vm_network
    content {
      model     = network.value.model
      bridge    = network.value.bridge
      tag       = network.value.tag
    }
  }
  dynamic "disk" {
    for_each = var.vm_disk
    content {
      type       = disk.value.type
      storage    = disk.value.storage
      size       = disk.value.size
      format     = disk.value.format
      ssd        = disk.value.ssd
    }
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=${var.vm_ipaddr}${var.vm_ipcidr},gw=${var.vm_ipgw}"
  sshkeys = var.vm_sshkeys
  ciuser = var.vm_defaultusername
  cipassword = var.vm_defaultpassword

  connection {
    type     = "ssh"
    user     = var.vm_defaultusername
    password = var.vm_defaultpassword
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