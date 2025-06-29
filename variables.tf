# Proxmox Provider Variables
variable "proxmox_url" {
  type        = string
  description = "Proxmox API URL (e.g., https://192.168.1.100:8006/api2/json)"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API Token ID"
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "Proxmox API Token Secret"
  sensitive   = true
}

# Proxmox Node Configuration
variable "proxmox_node" {
  type        = string
  description = "The Proxmox node to deploy VMs on"
  default     = "pve" # ご自身のノード名に合わせて変更してください
}

variable "vm_template_name" {
  type        = string
  description = "The name of the VM template to clone"
  default     = "ubuntu-2204-cloudinit-template"
}

# Network Configuration
variable "network_bridge" {
  type        = string
  description = "Proxmox network bridge for the VMs"
  default     = "vmbr0"
}

variable "network_gateway" {
  type        = string
  description = "Network gateway for the VMs"
}

# SSH Key for VM access
variable "ssh_public_key" {
  type        = string
  description = "Public SSH key to be installed on the VMs for user access"
  sensitive   = true
}

# Virtual Machine Definitions
variable "vms" {
  type = map(object({
    name        = string
    cores       = number
    sockets     = number
    memory      = number
    disk_size   = string
    ip_address  = string
    description = string
  }))
  description = "A map of virtual machines to create"
}