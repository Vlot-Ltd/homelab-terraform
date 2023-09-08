resource "proxmox_vm_qemu" "qemu_vm" {
    name = var.vm_name
    target_node = var.proxmox_host
    clone = var.vm_templatename
    full_clone = var.vm_fullclone
    clone_wait = var.vm_clonewait
    boot = var.vm_bootorder
    agent = var.vm_qemuagent
    sockets = var.vm_sockets
    cores = var.vm_cores
    memory = var.vm_memory
    desc = var.vm_description
    nameserver = var.vm_nameserver
    searchdomain = var.vm_searchdomain
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
    // Cloud Init Settings
    ipconfig0 = var.vm_ipconfig0
    sshkeys = var.vm_sshpublickey
    ciuser = var.vm_defaultusername
    cipassword = var.vm_defaultpassword
}

// Allow time for provisioning, initial boot, & cloud-init to complete before continuing.
resource "time_sleep" "wait_180_sec" {
  depends_on = [proxmox_vm_qemu.qemu_vm]
  create_duration = "180s"
}

// Post-provisioning pre-Ansible connectivity check before handoff to Ansible in parent module.
// Default timeout of 5 minutes.
//resource "null_resource" "provisioning" {
//  depends_on = [time_sleep.wait_90_sec]
//  provisioner "remote-exec" {

//    connection {
//      type            = var.provisioner_type
//      host            = var.ip_address
//      user            = var.default_image_username
//      password        = var.default_image_password
//      private_key     = var.private_key
//      target_platform = var.target_platform
      // WINRM specific arguments:
//      https           = true
//      insecure        = true
//    }
//  }
//}

// Allow more time for cloudinit and possible reboot
//resource "time_sleep" "wait_90_sec_again" {
//  depends_on = [null_resource.provisioning]
//  create_duration = "90s"
//}