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
  default     = "ubuntu-2204-cloudinit-template"
}

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

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = string
  default     = "20G"
}

variable "vm_ip" {
  description = "Static IP address with CIDR (e.g., 10.13.104.100/24). Leave empty for DHCP."
  type        = string
  default     = ""
}

variable "vm_gateway" {
  description = "Gateway IP address (e.g., 10.13.104.1)"
  type        = string
  default     = ""
}
