resource "proxmox_vm_qemu" "docker_host" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  target_node = var.target_node
  clone       = var.template_name
  full_clone  = true
  
  # Basic VM Settings - inherit from template or use defaults
  agent                  = 1
  define_connection_info = false
  os_type                = "cloud-init"
  
  # Hardware settings - must be specified, provider won't read from template
  cores    = var.vm_cores
  sockets  = 1
  cpu_type = "host"
  memory   = var.vm_memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  # Disk configuration - required to properly use cloned disk
  disks {
    scsi {
      scsi0 {
        disk {
          size     = var.vm_disk_size
          storage  = var.vm_storage
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = var.vm_storage
        }
      }
    }
  }

  # Network
  network {
    id     = 0
    model  = "virtio"
    bridge = var.vm_bridge
  }

  # Serial port for console access
  serial {
    id   = 0
    type = "socket"
  }

  # VGA setting for cloud-init
  vga {
    type = "serial0"
  }

  # Cloud-init network configuration (IP address)
  ipconfig0  = var.vm_ip != "" ? "ip=${var.vm_ip},gw=${var.vm_gateway}" : "ip=dhcp"
  nameserver = var.vm_nameserver

  # Ignore network MAC address changes
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}

# Auto-generate Ansible Inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl",
    {
      vms          = proxmox_vm_qemu.docker_host
      ssh_user     = var.ssh_user
      ssh_password = var.ssh_password
    }
  )
  filename = "../ansible/inventory/hosts.ini"
}
