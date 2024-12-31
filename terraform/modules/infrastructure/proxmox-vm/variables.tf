variable "proxmox_api_url" {
  description = "This is the target Proxmox API endpoint"
  type        = string
  default     = "https://192.168.1.20:8006/api2/json"
}

variable "proxmox_host" {
  description = "Proxmox host to build VM on"
  type        = string
  default     = "proxmox"
}

variable "proxmox_ignore_tls" {
  description = "Disable TLS verification while connecting"
  type        = string
  default     = "true"
}

variable "proxmox_token" {
  description = "API user token. Required, sensitive, or use environment variable TF_VAR_proxmox_token"
  type        = string
  sensitive   = true
}

variable "proxmox_user" {
  description = "This is the Proxmox API user. Use root@pam or custom. Will need PVEDatastoreUser, PVEVMAdmin, PVETemplateUser permissions"
  type        = string
  sensitive   = true
}

variable "vm_bootorder" {
  description = "VM boot order. The Telmate provider has a bug, this module implements the workaround. Ref: https://github.com/Telmate/terraform-provider-proxmox/issues/282."
  type        = string
  default     = "order=virtio0;ide2;net0"
}

variable "vm_clonewait" {
  description = "Time provider waits after a clone operation. Changed from default of 15 to speed things up"
  type        = number
  default     = 5
}

variable "vm_cores" {
  description = "The number of CPU cores per CPU socket to allocate to the VM."
  type        = number
  default     = 2
}

variable "vm_defaultpassword" {
  description = "Password for default user baked into template image, used for initial connection for configuration"
  type        = string
  default     = "proxmox"
}

variable "vm_defaultusername" {
  description = "Username baked into template image, used for initial connection for configuration"
  type        = string
  default     = "proxmox"
}

variable "vm_description" {
  description = "Sets the description seen in the web interface"
  type        = string
  default     = "VM created with Terraform"
}

variable "vm_disk" {
  description = "Specify disk variables"
  type        = list(object({
    type        = string
    storage     = string
    size        = string
    format      = string
    ssd         = number
  }))
  default     = [
    {
      type        = "scsi"
      storage     = "vmosstorage"
      size        = "50G"
      format      = "raw"
      ssd         = 0
    }
  ]
}

variable "vm_fullclone" {
  description = "Set to true to create a full clone, or false to create a linked clone."
  type        = bool
  default     = true
}

variable "vm_ipaddress" {
  description = "IP address of the VM"
  type        = string
}

variable "vm_ipcidr" {
  description = "IP network segment"
  type        = string
  default     = "/24"
}

variable "vm_ipgw" {
  description = "IP default gateway"
  type        = string
  default     = "192.168.1.254"
}

##variable "vm_ipconfig0" {
  ##description = "The first IP address to assign to the guest."
  ##type        = string
##}

variable "vm_memory" {
  description = "A number containing the amount of RAM to assign to the container (in MB)."
  type        = string
  default     = "2048"
}

variable "vm_name" {
  description = "The name of the VM within Proxmox."
  type        = string
  default     = "TempVM"
}

variable "vm_nameserver" {
  description = "The DNS server IP address used by the container"
  type        = string
  default     = "192.168.1.6"
}

variable "vm_network" {
  description = "Specify network devices"
  type        = list(object({
    model       = string
    bridge      = string
    tag         = number
  }))
  default     = [
    {
      model     = "virtio"
      bridge    = "vmbr0"
      tag       = null
    }
  ]
}

variable "vm_onboot" {
  description = "A boolean that determines if the container will start on boot."
  type        = bool
  default     = true
}

variable "vm_provisionertype" {
  description = "Connection type that should be used by Terraform. Valid types are ssh and winrm"
  type        = string
  default     = "ssh"
}

variable "vm_qemuagent" {
  description = "1 enables QEMU Guest Agent, 0 disables. Must run the qemu-guest-agent daemon in the quest for this to have any effect."
  type        = number
  default     = 1
}

variable "vm_searchdomain" {
  description = "Sets the DNS search domains for the container"
  type        = string
  default      = "local"
}

variable "vm_serial" {
  description = "Create a serial device inside the VM. Serial interface of type socket is used by xterm.js. Using a serial device as terminal"
  type        = object({
    id          = number
    type        = string
  })
  default     = {
    id          = 0
    type        = "socket"
  }
}

variable "vm_sockets" {
  description = "The number of CPU sockets to allocate to the VM."
  type        = number
  default     = 1
}

variable "vm_sshkeys" {
  description = "Temp SSH public key that will be added to the container"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILw4mdBvAc7uevh7LvM9tJ+wlRW1h9rCChdyzHIjYkHe"
}

variable "vm_targetplatform" {
  description = "Target platform Terraform provisioner connects to. Valid values are windows and unix"
  type        = string
  default     = "unix"
}

variable "vm_templatename" {
  description = "Template name to use"
  type        = string
  default     = "tpl-ubuntu-22-04"
}