resource "vsphere_datacenter" "datacenter" {
  name = "datacenter"
}

resource "vsphere_compute_cluster" "compute_cluster" {
   name            = "cluster"
    datacenter_id   = vsphere_datacenter.datacenter.moid
    host_system_ids = [ vsphere_host.ESXi1.id, vsphere_host.ESXi2.id ]

   drs_enabled          = true
   drs_automation_level = "fullyAutomated"

   ha_enabled = true
   depends_on = [
    vsphere_datacenter.datacenter
    ]
}
data "vsphere_virtual_machine" "template" {
  name          = "VM-Template"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "VM-Ansible"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 1024
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "hello-world"
        domain    = "example.com"
      }





data "vsphere_datastore" "datastore2" {
  datacenter_id = vsphere_datacenter.datacenter.moid
  name = "datastore1"

}
data "vsphere_datastore" "datastore1" {
 datacenter_id = vsphere_datacenter.datacenter.moid
  name = "datastore1 (1)"

}
 
data "vsphere_host_thumbprint" "ESXi2_thumbprint" {
  address = "192.168.19.12"
  insecure = true
}

resource "vsphere_host" "ESXi2" {
  hostname = "192.168.19.12"
  username = "root"
  password = "user1234!"
  datacenter = vsphere_datacenter.datacenter.moid
  #cluster  = vsphere_compute_cluster.compute_cluster.id
  thumbprint = data.vsphere_host_thumbprint.ESXi2_thumbprint.id
}

data "vsphere_host_thumbprint" "ESXi1_thumbprint" {
  address = "192.168.19.133"
  insecure = true
}

resource "vsphere_host" "ESXi1" {
  hostname = "192.168.19.133"
  username = "root"
  password = "user1234!"
  datacenter = vsphere_datacenter.datacenter.moid
  #cluster  = vsphere_compute_cluster.compute_cluster.id
  thumbprint = data.vsphere_host_thumbprint.ESXi1_thumbprint.id
}