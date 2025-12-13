# Proxmox VM Management with Terraform & Ansible

This project automates the provisioning of Virtual Machines on Proxmox using Terraform and configures them with Docker using Ansible.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & Docker Compose installed
- A running Proxmox VE instance
- A Cloud-Init capable VM template on Proxmox (e.g., `ubuntu-template-2`)

## Quick Start

### 1. Configure Terraform Variables

1. Navigate to the `terraform` directory:
   ```bash
   cd terraform
   ```

2. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Edit `terraform.tfvars` with your settings:
   ```hcl
   # Proxmox Connection
   proxmox_api_url  = "https://YOUR_PROXMOX_IP:8006/api2/json"
   proxmox_user     = "root@pam"
   proxmox_password = "YOUR_PASSWORD"
   target_node      = "YOUR_NODE_NAME"
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
   ```

### 2. Provision VMs with Terraform

All Terraform commands are run via Docker Compose:

```bash
cd terraform

# Initialize Terraform (first time only)
docker compose run --rm init

# Preview changes
docker compose run --rm plan

# Create VMs
docker compose run --rm apply

# Destroy VMs
docker compose run --rm destroy
```

This will:
- Create the specified number of VMs on Proxmox cloned from your template
- Configure the IP address via Cloud-Init
- Automatically generate an Ansible inventory file at `../ansible/inventory/hosts.ini`

### 3. Configure VMs with Ansible

1. Navigate to the `ansible` directory:
   ```bash
   cd ../ansible
   ```

2. Run the Docker installation playbook:
   ```bash
   ansible-playbook playbooks/install-docker.yml
   ```

This will connect to the new VMs and install Docker Engine, CLI, and Compose.

## Terraform Commands Reference

| Command | Description |
|---------|-------------|
| `docker compose run --rm init` | Initialize Terraform providers |
| `docker compose run --rm plan` | Preview infrastructure changes |
| `docker compose run --rm apply` | Create/update infrastructure |
| `docker compose run --rm destroy` | Destroy all managed infrastructure |

## Configuration Variables

### Proxmox Connection

| Variable | Description | Example |
|----------|-------------|---------|
| `proxmox_api_url` | Proxmox API endpoint | `https://10.13.104.211:8006/api2/json` |
| `proxmox_user` | Proxmox username | `root@pam` |
| `proxmox_password` | Proxmox password | `your_password` |
| `target_node` | Proxmox node name | `pureewat` |
| `template_name` | VM template to clone | `ubuntu-template-2` |

### VM Settings

| Variable | Description | Default |
|----------|-------------|---------|
| `vm_count` | Number of VMs to create | `1` |
| `vm_name_prefix` | VM name prefix | `docker-node` |
| `vm_cores` | CPU cores | `4` |
| `vm_memory` | RAM in MB | `4096` |
| `vm_disk_size` | Disk size | `50G` |
| `vm_storage` | Storage location | `local-lvm` |
| `vm_bridge` | Network bridge | `vmbr0` |

### Network Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `vm_ip` | Static IP with CIDR (empty for DHCP) | `10.13.104.100/24` |
| `vm_gateway` | Gateway IP | `10.13.104.254` |
| `vm_nameserver` | DNS server | `8.8.8.8` |

## Directory Structure

```
manage-VM/
├── terraform/
│   ├── docker-compose.yml  # Docker commands for Terraform
│   ├── Dockerfile          # Terraform container image
│   ├── main.tf             # VM resource definition
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Output definitions
│   ├── providers.tf        # Proxmox provider config
│   ├── terraform.tfvars    # Your configuration (git-ignored)
│   └── templates/
│       └── inventory.tftpl # Ansible inventory template
├── ansible/
│   ├── ansible.cfg         # Ansible configuration
│   ├── inventory/          # Generated inventory directory
│   └── playbooks/
│       └── install-docker.yml # Docker installation playbook
└── README.md
```

## Important Notes

> **Note**: The Proxmox Terraform provider does NOT inherit hardware settings from the template. You must explicitly specify `vm_cores`, `vm_memory`, and `vm_disk_size` in your `terraform.tfvars` to match your desired configuration.

> **Tip**: To create multiple VMs, increase `vm_count`. Each VM will be named with an incremented suffix (e.g., `docker-node-1`, `docker-node-2`).
