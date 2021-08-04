## provider setup
terraform {
	required_providers {
		vsphere	= "~> 2.0"
		avi	= {
			source  = "vmware/avi"
			version = ">= 20.1.6"
		}
	}
}
provider "vsphere" {
	vsphere_server		= var.vcenter_server
	user			= var.vcenter_username
	password		= var.vcenter_password
	allow_unverified_ssl	= true
}

module "avi-controller-a" {
	source		= "./module-avi-controller"

	# vsphere  parameters
	vcenter_server		= "vcenter.lab01.one"
	vcenter_username	= "administrator@vsphere.local"
	vcenter_password	= "VMware1!SDDC"
	datacenter		= "lab01"

	# avi parameters
	avi_server		= "avic-east.lab01.one"
	avi_username		= "admin"
	avi_password		= "VMware1!SDDC"
	avi_version		= "20.1.6"

	# vcenter cloud configuration
	cloud_name		= "tf-vmware-cloud"
	vcenter_license_tier	= "ENTERPRISE"
	vcenter_license_type	= "LIC_CORES"
	vcenter_configuration	= {
		username		= "administrator@vsphere.local"
		password		= "VMware1!SDDC"
		vcenter_url		= "vcenter.lab01.one"
		datacenter		= "lab01"
		management_network	= "pg-mgmt"
		privilege		= "WRITE_ACCESS"
	}
}

module "avi-controller-b" {
	source		= "./module-avi-controller"

	# vsphere  parameters
	vcenter_server		= "vcenter.lab01.one"
	vcenter_username	= "administrator@vsphere.local"
	vcenter_password	= "VMware1!SDDC"
	datacenter		= "lab01"

	# avi parameters
	avi_server		= "avic-west.lab01.one"
	avi_username		= "admin"
	avi_password		= "VMware1!SDDC"
	avi_version		= "20.1.6"

	# vcenter cloud configuration
	cloud_name		= "tf-vmware-cloud"
	vcenter_license_tier	= "ENTERPRISE"
	vcenter_license_type	= "LIC_CORES"
	vcenter_configuration	= {
		username		= "administrator@vsphere.local"
		password		= "VMware1!SDDC"
		vcenter_url		= "vcenter.lab01.one"
		datacenter		= "lab01"
		management_network	= "pg-mgmt"
		privilege		= "WRITE_ACCESS"
	}
}
