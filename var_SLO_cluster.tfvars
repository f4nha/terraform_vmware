##vSphere vars
#vsphere_user           = ""
#vsphere_password       = ""
vsphere_datacenter     = "London-DC"
vsphere_cluster        = "DEV-Cluster"
vsphere_res_pool       = "DEV-Cluster/Resources"

#Storage is linked to the Cluster level so i will the var here
vm_datastore = ["A-GOLD", "B-GOLD", "A-SILVER", "B-SILVER"]
