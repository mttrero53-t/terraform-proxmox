terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.40.0"
    }
  }
}

# Proxmox Provider Configuration
provider "proxmox" {
  endpoint  = var.proxmox_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true  # 自己署名証明書を使用している場合
}

# Create multiple VMs based on the 'vms' variable
resource "proxmox_virtual_environment_vm" "server" {
  for_each = var.vms

  # VM General Settings
  name        = each.value.name
  node_name   = var.proxmox_node
  description = each.value.description

  # Enable initialization (cloud-init)
  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/24"
        gateway = var.network_gateway
      }
    }
    
    user_account {
      keys     = [file(var.ssh_public_key)]
      password = var.vm_user_password
      username = var.vm_username
    }
  }

  # Enable QEMU Guest Agent
  agent {
    enabled = true
  }

  # Clone from template
  clone {
    vm_id = var.vm_template_id
  }

  # VM Resources
  cpu {
    cores   = each.value.cores
    sockets = each.value.sockets
  }
  
  memory {
    dedicated = each.value.memory
  }

  # VM Disk
  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = each.value.disk_size
  }

  # VM Network
  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  # Operating System Type (Linux)
  operating_system {
    type = "l26"  # Linux 2.6+ Kernel
  }

  # Start VM after creation
  started = true
}