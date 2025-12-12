resource "proxmox_vm_qemu" "docker_host" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  target_node = var.target_node
  clone       = var.template_name
  
  # Basic VM Settings
  agent                  = 0
  define_connection_info = false
  os_type     = "cloud-init"
  cores       = var.vm_cores
  sockets     = 1
  cpu_type    = "host"
  memory      = var.vm_memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

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

  ipconfig0 = var.vm_ip != "" ? "ip=${var.vm_ip},gw=${var.vm_gateway}" : "ip=dhcp"
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
