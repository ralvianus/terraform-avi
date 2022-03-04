#
# Configure the providers to connect to the NSX-T, vCenter, and AVI

terraform {
  required_version = ">= 0.13.6"

  required_providers {
    avi = {
      source = "vmware/avi"
      version = "21.1.3"
    }
    vsphere = {
      source = "hashicorp/vsphere"
    }
    nsxt = {
      source = "vmware/nsxt"
      version = "3.2.5"
    }
    time = {
      source = "hashicorp/time"
      version = "0.7.2"
    }
  }
}

provider "avi" {
  avi_username   = var.avi_username
  avi_password   = var.avi_password
  avi_controller = var.avi_server
  avi_tenant     = var.tenant
  avi_version    = var.avi_version
}

provider "vsphere"{
  user = var.vcenter_username
  password = var.vcenter_password
  vsphere_server = var.vcenter_server
  allow_unverified_ssl = true
}

provider "nsxt"{
  host = var.nsxt_cloud_url
  username = var.nsxt_cloud_username
  password = var.nsxt_cloud_password
  allow_unverified_ssl = true
}

provider "time" {
  # Configuration options
}

#
# Define the data sources
#

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_content_library" "content_library" {
  name = var.content_library_name
}

data "nsxt_transport_zone" "nsxt_mgmt_tz_name" {
  display_name = var.nsxt_cloud_mgmt_tz_name
}

data "nsxt_transport_zone" "nsxt_data_tz_name" {
  display_name = var.nsxt_cloud_data_tz_name
}

data "avi_cloud" "default" {
        name = "Default-Cloud"
}

#
# Creating the resources
#

# This allows enough time to pass in order to do a data.avi_network.avi_vip collection.
# data.avi_network.avi_vip is depends_on the time_sleep.wait_20_seconds
resource "time_sleep" "wait_20_seconds" {
  depends_on = [avi_cloud.nsxt_cloud]
  create_duration = "20s"
}

# Creating the content library in vCenter
resource "vsphere_content_library" "content_library" {
  name            = var.content_library_name
  storage_backing = [data.vsphere_datastore.datastore.id]
  description     = "Content library for AVI"
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

# Credential used to authenticate to NSX-T
resource "avi_cloudconnectoruser" "nsxt_cred" {
  name = var.nsxt_cloud_cred_name
  tenant_ref = var.tenant
  nsxt_credentials {
    username = var.nsxt_cloud_username
    password = var.nsxt_cloud_password
  }
}

# Credential used to authenticate to vCenter
resource "avi_cloudconnectoruser" "vcsa_cred" {
  name = var.vcsa_cred_name
  tenant_ref = var.tenant
  vcenter_credentials {
    username = var.vcenter_username
    password = var.vcenter_password
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
			domain_name  = "lb.lab01.one"
			pass_through = false
			record_ttl   = 30
		}
	}
}

# Create NSX-T Cloud
resource "avi_cloud" "nsxt_cloud" {
  name = var.cloud_name
  tenant_ref = var.tenant
  vtype = "CLOUD_NSXT"
  dhcp_enabled = true
  obj_name_prefix = var.nsxt_cloud_prefix
  dns_provider_ref = avi_ipamdnsproviderprofile.tf-dns-vmw.id
  ipam_provider_ref = avi_ipamdnsproviderprofile.tf-ipam-vmw.id
  nsxt_configuration {
      nsxt_credentials_ref = avi_cloudconnectoruser.nsxt_cred.uuid
      # transport_zone = data.nsxt_transport_zone.nsxt_mgmt_tz_name.id
      nsxt_url = var.nsxt_cloud_url
      management_network_config {
        tz_type = var.nsxt_cloud_mgmt_tz_type
        transport_zone = data.nsxt_transport_zone.nsxt_mgmt_tz_name.id
        mgmt_segment_id = var.mgmt_segment_id
      }
      data_network_config {
        tz_type = var.nsxt_cloud_mgmt_tz_type
        transport_zone = data.nsxt_transport_zone.nsxt_mgmt_tz_name.id
        tier1_segment_config {
          segment_config_mode = "TIER1_SEGMENT_MANUAL"
          manual {
            tier1_lrs {
              tier1_lr_id = var.nsxt_cloud_lr1
              segment_id = var.nsxt_cloud_overlay_seg
            }
          }
        }
      }
    }
}

# Associate vCenter & Content Library to NSX-T Cloud
resource "avi_vcenterserver" "vcenter_server" {
    name = var.nsxt_cloud_vcenter_name
    tenant_ref = var.tenant
    cloud_ref = avi_cloud.nsxt_cloud.id
    vcenter_url = var.vcenter_server
    content_lib {
      id = vsphere_content_library.content_library.id
    }
    vcenter_credentials_ref = avi_cloudconnectoruser.vcsa_cred.uuid
}
