output "vm_ipv4_addresses" {
  value = {
    for instance in proxmox_vm_qemu.docker_host :
    instance.name => instance.default_ipv4_address
  }
}
