proxmox_api_url = "https://10.13.104.211:8006/api2/json"
proxmox_api_token_id = "root@pam!terraform"
proxmox_api_token_secret = "5900448e-6d18-453d-9abe-0a74941cf876"
target_node = "pureewat"
template_name = "ubuntu-2204-cloudinit-template"

vm_count = 1
vm_memory = 4096
vm_cores = 4
vm_disk_size = "40G"
vm_ip = "10.13.104.100/24"
vm_gateway = "10.13.104.1"
