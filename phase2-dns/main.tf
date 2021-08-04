module "avic-east" {
	source		= "./avic-east"

	# avi parameters
	avi_server	   = "avic-east.lab01.one"
	avi_username	 = "admin"
	avi_password	 = "VMware1!SDDC"
	avi_version	   = "20.1.6"

	# dns service
	cloud_name	= "tf-vmware-cloud"
	vs_name		  = "avi-ns1"
	vs_fqdn		  = "avi-ns1.apps.lab01.one"
	vs_address	= "172.16.10.120"

	# Static DNS record
	api_static_fqdn         = "api.ocp-east.lab01.one"
	api_static_fqdn_ip      = "172.16.10.251"
	ingress_static_fqdn     = "apps.ocp-east.lab01.one"
	ingress_static_fqdn_ip  = "172.16.10.252"
}

module "avic-west" {
	source		= "./avic-west"

	# avi parameters
	avi_server	   = "avic-west.lab01.one"
	avi_username	 = "admin"
	avi_password	 = "VMware1!SDDC"
	avi_version	   = "20.1.6"

	# dns service
	cloud_name	= "tf-vmware-cloud"
	vs_name		  = "avi-ns2"
	vs_fqdn		  = "avi-ns1.apps.lab01.one"
	vs_address	= "172.16.10.130"

	# Static DNS record
	api_static_fqdn         = "api.ocp-west.lab01.one"
	api_static_fqdn_ip      = "172.16.10.151"
	ingress_static_fqdn     = "apps.ocp-west.lab01.one"
	ingress_static_fqdn_ip  = "172.16.10.152"


}
