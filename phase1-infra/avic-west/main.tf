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

provider "avi" {
	avi_controller		= var.avi_server
	avi_username		= var.avi_username
	avi_password		= var.avi_password
	avi_version		= var.avi_version
	avi_tenant		= "admin"
}

## vsphere objects
data "vsphere_datacenter" "datacenter" {
	name          = var.datacenter
}
data "vsphere_compute_cluster" "cmp" {
	name          = "cmp"
	datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_compute_cluster" "mgmt" {
	name          = "mgmt"
	datacenter_id = data.vsphere_datacenter.datacenter.id
}

## avi objects
data "avi_tenant" "tenant" {
	name = "admin"
}
data "avi_cloud" "default" {
        name = "Default-Cloud"
}

## create a vip IP pool in Default-Cloud to break a circular cloud_ref dependency
## this is required to bootstrap a network object and IP pool to create the ipam profile
## Default-Cloud is not used for service engine or virtual service placement
resource "avi_network" "ls-vip-pool" {
        name			= "ls-vip-pool"
	cloud_ref		= data.avi_cloud.default.id
	dhcp_enabled		= false
	ip6_autocfg_enabled	= false
	configured_subnets {
		prefix {
			ip_addr {
				addr = "172.16.20.0"
				type = "V4"
			}
			mask = 24
		}
		static_ip_ranges {
			type  = "STATIC_IPS_FOR_VIP"
			range {
				begin {
					addr = "172.16.20.101"
					type = "V4"
				}
				end {
					addr = "172.16.20.199"
					type = "V4"
				}
			}
		}
	}
}

## refer to above vip pool in ipam profile
resource "avi_ipamdnsproviderprofile" "tf-ipam-vmw" {
	name	= "tf-ipam-vmw"
	type	= "IPAMDNS_TYPE_INTERNAL"
	internal_profile {
		usable_networks {
			nw_ref = avi_network.ls-vip-pool.id
		}
	}
}

## create a dns profile
resource "avi_ipamdnsproviderprofile" "tf-dns-vmw" {
	name	= "tf-dns-vmw"
	type	= "IPAMDNS_TYPE_INTERNAL_DNS"
	internal_profile {
		dns_service_domain {
			domain_name  = "apps.lab01.one"
			pass_through = false
			record_ttl   = 1
		},
		dns_service_domain {
			domain_name  = "apps.ocp-west.lab01.one"
			pass_through = false
			record_ttl   = 1
		}
	}
}

## create a vcenter cloud and attach dns + ipam profiles
resource "avi_cloud" "cloud" {
	name         = var.cloud_name
	vtype        = "CLOUD_VCENTER"
	tenant_ref   = data.avi_tenant.tenant.id
	license_tier = var.vcenter_license_tier
	license_type = var.vcenter_license_type
	dhcp_enabled = true
	vcenter_configuration {
		username		= var.vcenter_configuration.username
		password		= var.vcenter_configuration.password
		vcenter_url		= var.vcenter_configuration.vcenter_url
		datacenter		= var.vcenter_configuration.datacenter
		management_network	= var.vcenter_configuration.management_network
		privilege		= var.vcenter_configuration.privilege
	}
	dns_provider_ref = avi_ipamdnsproviderprofile.tf-dns-vmw.id
	ipam_provider_ref = avi_ipamdnsproviderprofile.tf-ipam-vmw.id
	lifecycle {
		ignore_changes = [
			vcenter_configuration
		]
	}
}

## Network for pg-mgmt
resource "avi_network" "pg-mgmt" {
        name			= "pg-mgmt"
	cloud_ref		= avi_cloud.cloud.id
	dhcp_enabled		= true
	ip6_autocfg_enabled	= false
	configured_subnets {
		prefix {
			ip_addr {
				addr = "172.16.10.0"
				type = "V4"
			}
			mask = 24
		}
		static_ip_ranges {
			type  = "STATIC_IPS_FOR_VIP"
			range {
				begin {
					addr = "172.16.10.226"
					type = "V4"
				}
				end {
					addr = "172.16.10.250"
					type = "V4"
				}
			}
		}
	}
	depends_on = [
		avi_cloud.cloud
	]
}

resource "avi_ipamdnsproviderprofile" "tf-ipam-vmw-update" {
	name	= "tf-ipam-vmw"
	type	= "IPAMDNS_TYPE_INTERNAL"
	internal_profile {
		usable_networks {
			nw_ref = avi_network.pg-mgmt.id
		}
	}
}

## update the service engine Default-Group to map to cmp cluster
resource "avi_serviceenginegroup" "cmp-se-group" {
	name			= "Default-Group"
	cloud_ref		= avi_cloud.cloud.id
	tenant_ref		= data.avi_tenant.tenant.id
	se_name_prefix		= "cmp"
	max_se			= 4
	#buffer_se		= 0
	se_deprovision_delay	= 1
	vcenter_clusters {
		cluster_refs	= [
			"https://avic.lab01.one/api/vimgrclusterruntime/${data.vsphere_compute_cluster.cmp.id}-${avi_cloud.cloud.uuid}"
		]
		include		= true
	}
}

## create a new service engine group and map to mgmt cluster
resource "avi_serviceenginegroup" "mgmt-se-group" {
	name			= "mgmt-se-group"
	cloud_ref		= avi_cloud.cloud.id
	tenant_ref		= data.avi_tenant.tenant.id
	se_name_prefix		= "mgmt"
	max_se			= 2
	#buffer_se		= 0
	se_deprovision_delay	= 1
	vcenter_clusters {
		cluster_refs	= [
			"https://avic.lab01.one/api/vimgrclusterruntime/${data.vsphere_compute_cluster.mgmt.id}-${avi_cloud.cloud.uuid}"
		]
		include		= true
	}
}

## update the service engine openshift-seg to map to cmp cluster
resource "avi_serviceenginegroup" "openshift-seg" {
	name			= "openshift-seg"
	cloud_ref		= avi_cloud.cloud.id
	tenant_ref		= data.avi_tenant.tenant.id
	se_name_prefix		= "cmp"
	max_se			= 4
	#buffer_se		= 0
	se_deprovision_delay	= 1
	vcenter_clusters {
		cluster_refs	= [
			"https://avic.lab01.one/api/vimgrclusterruntime/${data.vsphere_compute_cluster.cmp.id}-${avi_cloud.cloud.uuid}"
		]
		include		= true
	}
}

## update the service engine tkg-seg to map to cmp cluster
resource "avi_serviceenginegroup" "tkg-seg" {
	name			= "tkg-seg"
	cloud_ref		= avi_cloud.cloud.id
	tenant_ref		= data.avi_tenant.tenant.id
	se_name_prefix		= "cmp"
	max_se			= 4
	#buffer_se		= 0
	se_deprovision_delay	= 1
	vcenter_clusters {
		cluster_refs	= [
			"https://avic.lab01.one/api/vimgrclusterruntime/${data.vsphere_compute_cluster.cmp.id}-${avi_cloud.cloud.uuid}"
		]
		include		= true
	}
}
