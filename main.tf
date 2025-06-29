# Proxmox Provider Configuration
provider "proxmox" {
  pm_api_url = var.proxmox_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true # 自己署名証明書の場合はtrueに設定
}

# Create multiple VMs based on the 'vms' variable
resource "proxmox_vm_qemu" "server" {
  for_each = var.vms

  # VM General Settings
  name        = each.value.name
  target_node = var.proxmox_node
  clone       = var.vm_template_name
  desc        = each.value.description

  # Enable QEMU Guest Agent
  agent = 1

  # VM Resources
  cores   = each.value.cores
  sockets = each.value.sockets
  memory  = each.value.memory

  # VM Disk
  scsihw = "virtio-scsi-pci"
  disk {
    type    = "scsi"
    storage = "local-lvm" # ストレージ名に合わせて変更してください
    size    = each.value.disk_size
  }

  # VM Network with Cloud-Init
  network {
    model  = "virtio"
    bridge = var.network_bridge
  }

  # Cloud-Init Settings
  # IPアドレス、ユーザー、SSHキーを設定
  ipconfig0 = "ip=${each.value.ip_address}/24,gw=${var.network_gateway}"
  sshkeys = var.ssh_public_key

  # 起動時にVMをリサイズし、Cloud-Initを実行
  os_type = "cloud-init"
}