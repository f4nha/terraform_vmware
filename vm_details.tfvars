#VM details vars
vm_name = "test-tf1"

vm_network = "dvPortGroup_vlan_slo_pbs-devserver"
vm_ip      = "10.44.39.215"
vm_netmask = "24"
vm_gateway = "10.44.39.254"
vm_domain  = "pt.playtech.corp"
vm_dns     = ["10.44.32.1", "10.33.38.11", "10.103.65.3"]

vm_template = "SLO_template_Centos7.7"
vm_cpu      = 4
vm_ram      = 8192