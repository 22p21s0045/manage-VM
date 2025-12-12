# Proxmox VM Management with Terraform & Ansible

This project automates the provisioning of Virtual Machines on Proxmox using Terraform and configures them with Docker using Ansible.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed
- A running Proxmox VE instance
- A Cloud-Init capable VM template on Proxmox (e.g., Ubuntu 22.04)

## Setup Instructions

### 1. Configure Terraform

1.  Navigate to the `terraform` directory:
    ```bash
    cd terraform
    ```

2.  Copy the example variables file:
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```

3.  Edit `terraform.tfvars` with your Proxmox credentials and settings:
    - `proxmox_api_url`: Your Proxmox API URL.
    - `proxmox_api_token_id` & `secret`: Your API token.
    - `target_node`: The name of your Proxmox node.
    - `template_name`: The exact name of your cloud-init template.
    - `ssh_public_key`: Your public SSH key content (e.g., from `~/.ssh/id_rsa.pub`).

### 2. Provision Infrastructure

Initialize and apply the Terraform configuration:

```bash
terraform init
terraform apply
```

This will:
- Create the specified number of VMs on Proxmox.
- Automatically generate an Ansible inventory file at `../ansible/inventory/hosts.ini`.

### 3. Configure VMs with Ansible

1.  Navigate to the `ansible` directory:
    ```bash
    cd ../ansible
    ```

2.  Run the Docker installation playbook:
    ```bash
    ansible-playbook playbooks/install-docker.yml
    ```

This will connect to the new VMs and install Docker Engine, CLI, and Compose.

## Directory Structure

```
├── terraform/
│   ├── main.tf             # VM resource definition
│   ├── variables.tf        # Input variables
│   ├── outputs.tf          # Output definitions
│   ├── providers.tf        # Proxmox provider config
│   └── templates/
│       └── inventory.tftpl # Ansible inventory template
├── ansible/
│   ├── ansible.cfg         # Ansible configuration
│   ├── inventory/          # Generated inventory directory
│   └── playbooks/
│       └── install-docker.yml # Docker installation playbook
└── README.md
```
