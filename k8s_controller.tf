resource "local_file" "cloud_init_controller_template" {
  content  = templatefile("${path.module}/ci_configs/k8s_controller.tftpl", { run_user = local.pve.user, ansible_repo = local.pve.ansible_repo })
  filename = "${path.module}/ci_configs/k8s_controller.yml"
}

resource "null_resource" "cloud_init_controller_config" {
  connection {
    type        = "ssh"
    user        = local.pve.user
    private_key = file("${local.pve.ssh_key_path}")
    host        = local.pve.host
  }

  provisioner "file" {
    source      = "${path.module}/ci_configs/k8s_controller.yml"
    destination = "/var/lib/vz/snippets/k8s_controller.yml"
  }
}

resource "proxmox_vm_qemu" "k8s_controller" {
  target_node = local.pve.node
  name        = "k8s-controller"
  desc        = "Kubernetes controller"
  vmid        = 800
  clone       = "Ubuntu-Server-2504-Template"
  agent       = 1
  memory      = 4096
  sockets     = 2
  cores       = 2
  cpu_type    = "x86-64-v2-AES"
  startup     = "order=1"

  bios   = "seabios"
  onboot = true
  boot   = "order=ide0;scsi0;ide2;net0"

  scsihw = "virtio-scsi-single"

  nameserver = local.pve.gateway
  ipconfig0  = "ip=${local.pve.network_prefix}0/24,gw=${local.pve.gateway},ip6=dhcp"
  cicustom   = "user=local:snippets/k8s_controller.yml"
  # Skip QEMU ipv6 to increase terrraform performance
  skip_ipv6 = true
  disks {
    scsi {
      scsi0 {
        disk {
          size     = "64G"
          storage  = local.pve.storage_pool
          cache    = "none"
          discard  = true
          iothread = true
          asyncio  = "io_uring"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = local.pve.storage_pool
        }
      }
      ide2 {
        cdrom {
          iso = ""
        }
      }
    }
  }

  network {
    id       = 0
    bridge   = local.pve.bridge
    model    = "virtio"
    firewall = true
  }
}
