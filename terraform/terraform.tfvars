# Proxmox Connection
proxmox_api_url  = "https://10.13.104.211:8006/api2/json"
proxmox_user     = "root@pam"
proxmox_password = "int53101"
target_node      = "pureewat"
template_name    = "ubuntu-template-2"

# VM Settings
vm_count       = 1
vm_name_prefix = "docker-node"

# Hardware (should match your template settings)
vm_cores     = 4
vm_memory    = 4096
vm_disk_size = "50G"
vm_storage   = "local-lvm"
vm_bridge    = "vmbr0"

# Network Configuration (IP address)
vm_ip         = "10.13.104.100/24"
vm_gateway    = "10.13.104.254"
vm_nameserver = "8.8.8.8"
