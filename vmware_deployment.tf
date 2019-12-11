###### Provider INFO #######

terraform {
  required_providers {
    local = "1.2.2"
  }
}

provider "vsphere" {

  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_vcenter}"

  # If you have a self-signed cert
  allow_unverified_ssl = "${var.vsphere_unverified_ssl}"
}
#############################

### data sources ###
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vm_datastore[0]}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_res_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vm_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vm_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


######### RESOURCES #########
##extra disk
#resource "vsphere_virtual_disk" "storage_disk" {
#  size       = 300
#  vmdk_path  = "${var.vm_name}_2.vmdk"
#  datacenter = "${data.vsphere_datacenter.dc.id}"
#  datastore  = "${var.vm_datastore}"
#  type       = "thin"
#}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_name}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"

  num_cpus  = "${var.vm_cpu}"
  memory    = "${var.vm_ram}"
  guest_id  = "centos64Guest"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "${var.vm_name}.vmdk"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  ##extra disk
  disk {
    label            = "${var.vm_name}_2.vmdk"
    path             = "${var.vm_name}_2.vmdk"
    size             = "300"
    thin_provisioned = "true"
    unit_number      = 1
    datastore_id     = "${data.vsphere_datastore.datastore.id}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      timeout = "90"

      linux_options {
        host_name = "${var.vm_name}"
        domain    = "${var.vm_domain}"
      }

      network_interface {
        ipv4_address = "${var.vm_ip}"
        ipv4_netmask = "${var.vm_netmask}"
      }

      ipv4_gateway    = "${var.vm_gateway}"
      dns_server_list = ["${var.vm_dns[0]}", "${var.vm_dns[1]}", "${var.vm_dns[2]}"]
    }
  }
###add stuff to run after vm is UP
  provisioner "remote-exec" {
    inline = [
      "echo '10.44.32.177 puppet' >> /etc/hosts ",
      "yum update -y",
      "echo ${var.vm_name} >> /etc/hostname",
      "echo ${var.vm_name} >> /etc/hosts",
      "echo ${var.vm_name}.pt.playtech.corp >> /etc/hosts",
      "puppet agent --enable",
      "puppet agent -t",
      "echo 'domains pt.playtech.corp lohs.geneity' >> /etc/resolv.conf" ,
    ]
    connection {
      host     = self.default_ip_address
      type     = "ssh"
      user     = "root"
      password = var.vm_rootpasswd
    }
  }

}