# terraform_vmware
deploy/clone vms to vmware vsphere

Setup your vars in vars.tf and the .tfvars
Set the vm details in the vm_details.tf


Run like this
      - terraform init
      - terraform plan -var="vsphere_user=${vsphere_user}" -var="vsphere_password=${vsphere_password}" -var-file="var_SLO_cluster.tfvars" -var-file="vm_details.tfvars" -var="vm_rootpasswd=${vm_rootpasswd}" -out vm_deploy.out
      - terraform apply -auto-approve "vm_deploy.out"


either set the vars manually in the var files or encrypt somehow

tks
TF
