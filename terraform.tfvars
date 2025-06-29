proxmox_url                = "https://<Promoxサーバーのホスト名 or IPアドレス>:8006/api2/json"
proxmox_api_token_id       = "<api_token_id>"
proxmox_api_token_secret   = "<token_secret>"

# Proxmox Configuration
proxmox_node     = "<node名>"
vm_template_id   = 9000  # テンプレートのID（数値）
storage_pool     = "local-lvm"
network_bridge   = "vmbr0"

# Network Configuration
network_gateway = "192.168.0.1"

# VM User Configuration
vm_username = "ubuntu"
# vm_user_password = "Passw0rd"  # オプション

# SSH Public Key (ファイルパス)
ssh_public_key = "~/.ssh/id_rsa.pub"

# Virtual Machine Definitions
vms = {
  "vm-01" = {
    name        = "vm-01"
    cores       = 1
    sockets     = 1
    memory      = xxx  # MB
    disk_size   = yyy  # GB
    ip_address  = "192.168.0.12"
    description = "VM-1 Node"
  },
    "vm-02" = {
    name        = "vm-02"
    cores       = 1
    sockets     = 1
    memory      = xxx  # MB
    disk_size   = yyy  # GB
    ip_address  = "192.168.0.16"
    description = "VM2 Node"
  }
}