terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=2.9.0>"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://${var.proxmox_api_url}:8006/api2/json"
    pm_password = var.proxmox_password
    pm_user = var.proxmox_user
    pm_otp = ""
}