##vSphere vars
#vsphere_user           = ""
#vsphere_password       = ""
vsphere_datacenter     = "London-SLO"
vsphere_cluster        = "SLO-PBS_Dev"
vsphere_res_pool       = "SLO-PBS_Dev/Resources"

#Storage is linked to the Cluster level so i will the var here
vm_datastore = ["MSA-VOL001-A-GOLD", "MSA-VOL001-B-GOLD", "MSA-VOL001-A-SILVER", "MSA-VOL001-B-SILVER"]