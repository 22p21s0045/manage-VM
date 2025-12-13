# Proxmox VM Management

Automate VM provisioning on Proxmox with Terraform and configure with Ansible using Docker.

## Prerequisites

- Docker & Docker Compose
- Proxmox VE with Cloud-Init VM template
- SSH key pair in `ssh/` directory

## Quick Start

### 1. Configure Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
```hcl
proxmox_api_url  = "https://YOUR_PROXMOX_IP:8006/api2/json"
proxmox_user     = "root@pam"
proxmox_password = "YOUR_PASSWORD"
target_node      = "YOUR_NODE_NAME"
template_name    = "ubuntu-template-2"

vm_count       = 1
vm_name_prefix = "docker-node"
vm_ip          = "10.13.104.100/24"
vm_gateway     = "10.13.104.254"
```

### 2. Run Commands

```bash
# Full setup (create VM + install everything)
make setup-all

# Or run individually:
make create-vm      # Create VM only
make init-vm        # Configure VM only
```

## Make Commands

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| **VM Creation (Terraform)** | |
| `make init-terraform` | Initialize Terraform |
| `make plan-vm` | Preview changes |
| `make create-vm` | Create VM |
| `make destroy-vm` | Destroy VM |
| **VM Configuration (Ansible)** | |
| `make init-vm` | Run all playbooks |
| `make install-docker` | Install Docker only |
| `make deploy-project` | Deploy project only |
| `make deploy-monitoring` | Deploy monitoring only |
| **Workflows** | |
| `make setup-all` | Full setup (create + configure) |
| `make clean` | Destroy everything |

## Directory Structure

```
manage-VM/
├── Makefile              # All commands
├── terraform/            # VM provisioning
│   ├── terraform.tfvars  # Your config (git-ignored)
│   └── ...
├── ansible/              # VM configuration
│   ├── inventory/        # Auto-generated
│   └── playbooks/
│       ├── site.yml              # All playbooks
│       ├── install-docker.yml
│       ├── deploy-project.yml
│       └── deploy-monitoring.yml
└── ssh/                  # SSH keys
```

## Notes

> **Important**: Configure `terraform.tfvars` before running any commands.

> **Tip**: Run `make help` to see all available commands.
