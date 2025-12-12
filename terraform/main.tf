resource "proxmox_vm_qemu" "docker_host" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  target_node = var.target_node
  clone       = var.template_name
  
  # Basic VM Settings
  agent                  = 1
  define_connection_info = false
  os_type     = "cloud-init"
  cores       = var.vm_cores
  sockets     = 1
  cpu_type    = "host"
  memory      = var.vm_memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  # Serial port for console access
  serial {
    id   = 0
    type = "socket"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.vm_disk_size
          storage = "local-lvm"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # VGA setting for cloud-init
  vga {
    type = "serial0"
  }

  # Cloud-init network configuration
  ipconfig0  = var.vm_ip != "" ? "ip=${var.vm_ip},gw=${var.vm_gateway}" : "ip=dhcp"
  nameserver = "8.8.8.8"
}

# Auto-generate Ansible Inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl",
    {
      vms = proxmox_vm_qemu.docker_host
    }
  )
  filename = "../ansible/inventory/hosts.ini"
}
