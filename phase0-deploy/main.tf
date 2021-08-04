terraform {
	required_providers {
		vsphere = "~> 2.0"
	}
}
provider "vsphere" {
	vsphere_server		= "vcenter.lab01.one"
	user			= "administrator@vsphere.local"
	password		= "VMware1!SDDC"
	allow_unverified_ssl	= true
}

module "avi-controller-a" {
	source		= "./module-avi-controller"

	### vsphere variables
	datacenter	= "core"
	cluster		= "core"
	datastore	= "ds-esx11"
	host		= "esx11.lab01.one"
	network		= "vss-vmnet"

	### appliance variables
	vm_name		= "avic-east.lab01.one"
	avi_endpoint = "avic-east.lab01.one"
	remote_ovf_url	= "http://172.16.10.1:9000/iso/controller-20.1.6-9132.ova"
	mgmt-ip		= "172.16.10.119"
	mgmt-mask	= "255.255.255.0"
	default-gw	= "172.16.10.1"

	### initial config
	admin-password	= "VMware1!SDDC"

	### DNS config
	dns-server = "172.16.10.1"
	domain = "lab01.one"
}

module "avi-controller-b" {
	source		= "./module-avi-controller"

	### appliance variables
	vm_name		= "avic-west.lab01.one"
	avi_endpoint = "avic-west.lab01.one"
	remote_ovf_url	= "http://172.16.10.1:9000/iso/controller-20.1.6-9132.ova"
	mgmt-ip		= "172.16.10.129"
	mgmt-mask	= "255.255.255.0"
	default-gw	= "172.16.10.1"

	### initial config
	admin-password	= "VMware1!SDDC"

	### DNS config
	dns-server = "172.16.10.1"
	domain = "lab01.one"
}
