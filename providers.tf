terraform {
  required_version = "1.11.4"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
}
