## provider setup
terraform {
	required_providers {
		avi = {
			source  = "vmware/avi"
			version = "21.1.4"
		}
		nsxt = {
      source = "vmware/nsxt"
      version = "3.2.5"
		}
	}
}

provider "avi" {
	avi_controller		= var.avi_server
	avi_username		= var.avi_username
	avi_password		= var.avi_password
	avi_version		= var.avi_version
	avi_tenant		= "admin"
}
provider "nsxt"{
  host = var.nsxt_cloud_url
  username = var.nsxt_cloud_username
  password = var.nsxt_cloud_password
  allow_unverified_ssl = true
}

## avi data objects
data "avi_tenant" "admin" {
	name	= "admin"
}
data "avi_cloud" "vmware" {
	name	= var.cloud_name
}
data "avi_cloud" "default" {
	name	= "Default-Cloud"
}
data "avi_serviceenginegroup" "default" {
	name	= "Default-Group"
}
data "avi_vrfcontext" "default" {
	cloud_ref = data.avi_cloud.default.id
}
data "avi_vrfcontext" "vmware" {
	cloud_ref = data.avi_cloud.vmware.id
}

## create NSX-T group for go-router
resource "nsxt_policy_group" "gorouter-group" {
  display_name = "gorouter"
  description  = "Terraform provisioned Go-Router Group"
}

resource "nsxt_policy_group" "pcf-control-group" {
  display_name = "pcf-control"
  description  = "Terraform provisioned pcf-control Group"
}

## Creating CA Certificate
#resource "avi_sslkeyandcertificate" "vmca" {
#    name = "terraform-example-foo"
#    tenant_ref = "/api/tenant/?name=admin"
#}

## create the health monitor
resource "avi_healthmonitor" "pcf-hmon-http" {
    name = "tf-pcf-gorouter-http-hmon"
    tenant_ref = data.avi_tenant.admin.id
		type = "HEALTH_MONITOR_HTTP"
		is_federated = false
		receive_timeout = "4"
		successful_checks = "2"
		failed_checks = "2"
		send_interval = "10"
		monitor_port = "8080"
		http_monitor {
			exact_http_request = false
			http_request = "GET /health HTTP/1.0"
			http_response_code = ["HTTP_2XX"]
		}
}

resource "avi_healthmonitor" "pcf-hmon-tcp" {
    name = "tf-pcf-gorouter-tcp-hmon"
    tenant_ref = data.avi_tenant.admin.id
		type = "HEALTH_MONITOR_HTTP"
		is_federated = false
		receive_timeout = "4"
		successful_checks = "2"
		failed_checks = "2"
		send_interval = "10"
		monitor_port = "80"
		http_monitor {
			exact_http_request = false
			http_request = "GET /health HTTP/1.0"
			http_response_code = ["HTTP_2XX"]
		}
}

resource "avi_healthmonitor" "pcf-hmon-ssh" {
    name = "tf-pcf-gorouter-ssh-hmon"
    tenant_ref = data.avi_tenant.admin.id
		type = "HEALTH_MONITOR_TCP"
		is_federated = false
		receive_timeout = "4"
		successful_checks = "2"
		failed_checks = "2"
		send_interval = "10"
		monitor_port = "2222"
}

## create the http profile
resource "avi_applicationprofile" "pcf-http-profile" {
    name = "tf-pcf-http-profile"
    tenant_ref	= data.avi_tenant.admin.id
		type = "APPLICATION_PROFILE_TYPE_HTTP"
		http_profile {
			connection_multiplexing_enabled = true
			xff_enabled = true
			xff_alternate_name = "X-Forwarded-For"
			x_forwarded_proto_enabled = true
		}
}

## create http pool
resource "avi_pool" "pcf-http-pool" {
    name = "tf-pcf-gorouter-http-pool"
    tenant_ref = data.avi_tenant.admin.id
		tier1_lr = var.nsxt_cloud_lr1
		default_server_port = "8080"
		enabled = true
		lb_algorithm = "LB_ALGORITHM_LEAST_CONNECTIONS"
		nsx_securitygroup = [nsxt_policy_group.gorouter-group.id]
		health_monitor_refs = [avi_healthmonitor.pcf-hmon-http.id]
}

## create tcp pool
resource "avi_pool" "pcf-tcp-pool" {
    name = "tf-pcf-gorouter-tcp-pool"
    tenant_ref = data.avi_tenant.admin.id
		tier1_lr = var.nsxt_cloud_lr1
		default_server_port = "80"
		enabled = true
		lb_algorithm = "LB_ALGORITHM_LEAST_CONNECTIONS"
		use_service_port = true
		nsx_securitygroup = [nsxt_policy_group.gorouter-group.id]
		health_monitor_refs = [avi_healthmonitor.pcf-hmon-tcp.id]
}

## create ssh pool
resource "avi_pool" "pcf-ssh-pool" {
    name = "tf-pcf-gorouter-ssh-pool"
    tenant_ref = data.avi_tenant.admin.id
		tier1_lr = var.nsxt_cloud_lr1
		default_server_port = "2222"
		enabled = true
		lb_algorithm = "LB_ALGORITHM_LEAST_CONNECTIONS"
		use_service_port = true
		nsx_securitygroup = [nsxt_policy_group.pcf-control-group.id]
		health_monitor_refs = [avi_healthmonitor.pcf-hmon-ssh.id]
}

## create the avi vip
resource "avi_vsvip" "pcf-vip" {
	name		= "tf-vip-${var.vs_name}"
	tenant_ref	= data.avi_tenant.admin.id
	cloud_ref	= data.avi_cloud.vmware.id
	tier1_lr = var.nsxt_cloud_lr1

	# static vip IP address
	vip {
		vip_id = "0"
		ip_address {
			type = "V4"
			addr = var.vs_address
		}
	}
}


## create the dns virtual service and attach vip
## create static DNS entries for Openshift cluster
resource "avi_virtualservice" "pcf-vs-http" {
	name			= "tf-vs-${var.vs_name}"
	tenant_ref		= data.avi_tenant.admin.id
	cloud_ref		= data.avi_cloud.vmware.id
	vsvip_ref		= avi_vsvip.pcf-vip.id
	application_profile_ref	= avi_applicationprofile.pcf-http-profile.id
	se_group_ref		= data.avi_serviceenginegroup.default.id
	services {
		port = 80
	}
	enabled			= true
}
