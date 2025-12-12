resource "proxmox_vm_qemu" "docker_host" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  target_node = var.target_node
  clone       = var.template_name
  
  # Basic VM Settings
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.vm_cores
  sockets     = 1
  cpu         = "host"
  memory      = var.vm_memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    slot    = 0
    size    = var.vm_disk_size
    type    = "scsi"
    storage = "local-lvm" # Change this if using Ceph or other storage
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud-Init Settings
  ipconfig0 = "ip=dhcp"
  
  ciuser  = var.ssh_user
  sshkeys = var.ssh_public_key
}

# Auto-generate Ansible Inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl",
    {
      vms = proxmox_vm_qemu.docker_host
      ssh_user = var.ssh_user
    }
  )
  filename = "../ansible/inventory/hosts.ini"
}
