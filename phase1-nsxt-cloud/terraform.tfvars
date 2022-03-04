
# vsphere  parameters
vcenter_server		= "vcenter.lab01.one"
vcenter_username	= "administrator@vsphere.local"
vcenter_password	= "VMware1!SDDC"
datacenter		= "lab01"
datastore	= "vsanDatastore"
content_library_name = "avi-cl"
nsxt_cloud_vcenter_name = "vcsa"
vcsa_cred_name = "vcsa-cred"

# avi parameters
avi_server		= "avic.lab01.one"
avi_username		= "admin"
avi_password		= "VMware1!SDDC"
avi_version		= "21.1.3"
tenant = "admin"

# NSX-T cloud configuration
nsxt_cloud_url = "172.16.10.117"
nsxt_cloud_username = "admin"
nsxt_cloud_password = "VMware1!SDDC"
nsxt_cloud_prefix = "tf"
cloud_name = "tf-nsxt-cloud"

nsxt_cloud_cred_name = "nsxt-cloud_cred"

nsxt_cloud_mgmt_tz_name = "tz-host-overlay"
nsxt_cloud_mgmt_tz_type = "OVERLAY"
nsxt_cloud_data_tz_name = "tz-host-overlay"
nsxt_cloud_data_tz_type = "OVERLAY"
nsxt_cloud_lr1 = "Avi"
nsxt_cloud_overlay_seg = "Avi-VIP"
nsxt_cloud_vip_subnet = "10.101.4.0"
nsxt_cloud_vip_subnet_mask = "22"
nsxt_cloud_vip_subnet_pool_begin = "10.101.6.100"
nsxt_cloud_vip_subnet_pool_end = "10.101.6.200"
nsxt_cloud_vip_static_route_gateway_subnet = "0.0.0.0"
nsxt_cloud_vip_static_route_gateway_subnet_mask = "0"
nsxt_cloud_vip_static_route_next_hop = "10.101.4.1"

# Other Paramters

avi_DNS_profile_name = "nsxt-cloud-DNS"
avi_DNS_profile_domain_name = "tfdemo.homelab.virtualizestuff.com"
avi_IPAM_profile_name = "nsxt-cloud-IPAM"
data_avi_network_avi_vip_name = "avi-mgmt-00"
data_avi_applicationprofile_system_dns_name = "System-DNS"

dns_vip_name = "tf-dns"



vs_name = "tf-dns"
vs_vip_static_address = "10.101.4.4"
vs_port = "53"
