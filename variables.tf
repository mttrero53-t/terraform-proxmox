# Proxmox Provider Variables
variable "proxmox_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API Token ID"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
  sensitive   = true
}

# Proxmox Node Configuration
variable "proxmox_node" {
  type        = string
  description = "The Proxmox node to deploy VMs on"
  default     = "pve"
}

variable "vm_template_id" {
  type        = number
  description = "The ID of the VM template to clone"
}

variable "disk_size" {
  type        = string
  description = "Default disk size for VMs (e.g., '50G')"
  default     = "50G"
}

variable "storage_pool" {
  type        = string
  description = "Proxmox storage pool for VM disks"
  default     = "local-lvm"
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

# VM User Configuration
variable "vm_username" {
  type        = string
  description = "Username for VM access"
  default     = "ubuntu"
}

variable "vm_user_password" {
  type        = string
  description = "Password for VM user (optional, if not using SSH keys only)"
  sensitive   = true
  default     = null
}

# SSH Key for VM access
variable "ssh_public_key" {
  type        = string
  description = "Path to public SSH key file to be installed on the VMs"
}

# Virtual Machine Definitions
variable "vms" {
  type = map(object({
    name        = string
    cores       = number
    sockets     = number
    memory      = number
    disk_size   = number
    ip_address  = string
    description = string
  }))
  description = "A map of virtual machines to create"
}