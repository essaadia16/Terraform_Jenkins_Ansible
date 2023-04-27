terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.3.1"
    }
  }
}

provider "vsphere" {
  # Configuration options
  user                 = "administrator@vsphere.local"
  password             = "User1234!"
  vsphere_server       = "192.168.19.134"
  allow_unverified_ssl = true
}