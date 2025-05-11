locals {
  environment_configs = {
    lab = {
      pve_user            = "root"
      pve_host            = "pve.yggdrasil"
      pve_node            = "pve"
      pve_storage_pool    = "local-lvm"
      pve_bridge          = "vmbr1"
      pve_controller_ip   = "192.168.70.70"
      pve_gateway         = "192.168.70.1"
      pve_network_prefix  = "192.168.70.7"
      ssh_key_path        = "~/.ssh/id_ed25519"
      ansible_repo        = "https://github.com/rmzamith/proxmox-ansible-k8s"
    }
  }


  _config = lookup(local.environment_configs, terraform.workspace, "lab")

  pve = {
    user            = try(local._config.pve_user, "root")
    host            = try(local._config.pve_host, "pve.yggdrasil")
    node            = try(local._config.pve_node, "pve")
    storage_pool    = try(local._config.pve_storage_pool, "local-lvm")
    bridge          = try(local._config.pve_bridge, "vmbr1")
    controller_ip   = try(local._config.pve_controller_up, "192.168.70.70")
    gateway         = try(local._config.pve_gateway, "192.169.70.1")
    network_prefix  = try(local._config.pve_network_prefix, "192.168.70.7")
    ssh_key_path    = try(local._config.ssh_key_path, "~/.ssh/id_ed25519")
    ansible_repo    = try(local._config.ansible_repo, "https://github.com/rmzamith/proxmox-ansible-k8s")
  }
}

