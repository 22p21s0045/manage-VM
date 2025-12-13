# Proxmox Connection
variable "proxmox_api_url" {
  description = "The URL of the Proxmox API (e.g. https://192.168.1.100:8006/api2/json)"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox username (e.g. root@pam)"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "target_node" {
  description = "The Proxmox node to deploy the VM on"
  type        = string
}

variable "template_name" {
  description = "The name of the VM template to clone"
  type        = string
  default     = "ubuntu-template-2"
}

# VM Count and Naming
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

variable "vm_name_prefix" {
  description = "Prefix for the VM names"
  type        = string
  default     = "docker-node"
}

# VM Hardware Settings (should match your template)
variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 4
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "Disk size (e.g., 40G)"
  type        = string
  default     = "40G"
}

variable "vm_storage" {
  description = "Storage location for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "vm_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

# Network Configuration (IP settings)
variable "vm_ip" {
  description = "Static IP address with CIDR (e.g., 10.13.104.100/24). Leave empty for DHCP."
  type        = string
  default     = ""
}

variable "vm_gateway" {
  description = "Gateway IP address (e.g., 10.13.104.254)"
  type        = string
  default     = ""
}

variable "vm_nameserver" {
  description = "DNS nameserver IP address"
  type        = string
  default     = "8.8.8.8"
}

# SSH/Ansible Settings
variable "ssh_user" {
  description = "SSH username for Ansible connection"
  type        = string
  default     = "ubuntu"
}

variable "ssh_password" {
  description = "SSH password for Ansible connection"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ssh_public_key" {
  description = "SSH public key to inject via cloud-init"
  type        = string
  default     = ""
}
