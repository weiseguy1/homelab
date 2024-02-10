variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}

source "proxmox" "alpine-13.9-1-server" {
  
  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username = "${var.proxmox_api_token_id}"
  token = "${var.proxmox_api_token_secret}"
  insecure_skip_tls_verify = true

  # VM General Settings
  node = "pve1"
  vm_id = "900"
  vm_name = "alpine-13.9-1-server"
  template_description = "Alpine Linux Server Image with basic tools installed"

  # VM OS Settings
  iso_url = "https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-standard-3.19.1-x86_64.iso"
  iso_checksum = "63e62f5a52cfe73a6cb137ecbb111b7d48356862a1dfe50d8fdd977d727da192"
  iso_storage_pool = "local"
  unmount_iso = true

  # VM System Settings
  # qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-pci"

  disks {
      disk_size = "20G"
      format = "qcow2"
      storage_pool = "local-lvm"
      storage_pool_type = "lvm"
      type = "sata"
  }

  # VM CPU Settings
  cores = "1"

  # VM Memory Settings
  memory = "2048"

  # VM Network Settings
  network_adapters {
      model = "virtio"
      bridge = "vmbr0"
      firewall = "false"
  }

  # VM Cloud-Init Settings
  cloud_init = true
  cloud_init_storage_pool = "local-lvm"

  # PACKER Boot Commands
  boot_command = [
    "root<enter><wait>",
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/answers<enter><wait>",
    "setup-alpine -f answers<enter><wait5>",
    "{{user `ssh_password`}}<enter><wait>",
    "{{user `ssh_password`}}<enter><wait5>",
    "<wait>y<enter><wait10>",
    "rc-service sshd stop<enter>",
    "mount /dev/sda3 /mnt<enter>",
    "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config<enter>",
    "umount /mnt<enter>",
    "reboot<enter>"
  ]
  boot = "c"
  boot_wait = "10s"

  # PACKER Autoinstall Settings
  http_directory = "http"
} 
