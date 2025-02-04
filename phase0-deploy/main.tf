terraform {
	required_providers {
		vsphere = "~> 2.0"
	}
}
provider "vsphere" {
	vsphere_server		= "vcenter-mgt.sgvbc.vcf"
	user			= "administrator@vsphere.local"
	password		= "VMware1!VMware1!"
	allow_unverified_ssl	= true
}

module "avi-controller" {
	source		= "./module-avi-controller"

	### vsphere variables
	datacenter	= "mgt-datacenter-01"
	cluster		= "mgt-cluster-01"
	datastore	= "mgt-vsan"
	host		= "esx11.sgvbc.vcf"
	network		= "mgt-vds01-vm"

	### appliance variables
	vm_name		= "avic.sgvbc.vcf"
	remote_ovf_url	= "http://10.66.78.252:9000/iso/controller-22.1.6-9191.ova"
	mgmt-ip		= "192.168.110.70"
	mgmt-mask	= "255.255.255.0"
	default-gw	= "192.168.110.1"

	### initial config
	admin-password	= "VMware1!VMware1!"

	### DNS config
	dns-server = "192.168.110.10"
	domain = "sgvbc.vcf"
}
