terraform {
	required_providers {
		vsphere = "~> 2.0"
	}
}
provider "vsphere" {
	vsphere_server		= "vcsa-01a.corp.vmw"
	user			= "administrator@vsphere.local"
	password		= "VMware1!"
	allow_unverified_ssl	= true
}

module "avi-controller" {
	source		= "./module-avi-controller"

	### vsphere variables
	datacenter	= "RegionA01"
	cluster		= "RegionA01-Compute"
	datastore	= "vol1"
	network		= "Management"

	### appliance variables
	vm_name		= "avic.corp.vmw"
	remote_ovf_url	= "https://truenas.corp.vmw:9000/iso/controller-21.1.4-9210.ova"
	mgmt-ip		= "192.168.110.87"
	mgmt-mask	= "255.255.255.0"
	default-gw	= "192.168.110.1"

	### initial config
	admin-password	= "VMware1!"

	### DNS config
	dns-server = "192.168.110.10"
	domain = "corp.vmw"
}
