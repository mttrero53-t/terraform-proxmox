output "vm_ip_addresses" {
  value = { for k, v in proxmox_vm_qemu.server : k => v.ipconfig0 }
  description = "The IP addresses of the created virtual machines."
}