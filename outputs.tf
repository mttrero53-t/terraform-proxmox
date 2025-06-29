output "vm_ip_addresses" {
  value = { 
    for k, v in proxmox_virtual_environment_vm.server : 
    k => v.initialization[0].ip_config[0].ipv4[0].address 
  }
  description = "The IP addresses of the created virtual machines."
}

output "vm_names" {
  value = { 
    for k, v in proxmox_virtual_environment_vm.server : 
    k => v.name 
  }
  description = "The names of the created virtual machines."
}