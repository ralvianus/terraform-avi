
# vsphere  parameters
vcenter_server		= "vcsa-01a.corp.vmw"
vcenter_username	= "administrator@vsphere.local"
vcenter_password	= "VMware1!"
datacenter		= "RegionA01"
datastore	= "vol1"
content_library_name = "avi-cl"
nsxt_cloud_vcenter_name = "vcsa"
vcsa_cred_name = "vcsa-cred"

# avi parameters
avi_server		= "avic.corp.vmw"
avi_username		= "admin"
avi_password		= "VMware1!"
avi_version		= "21.1.4"
tenant = "admin"

# NSX-T cloud configuration
nsxt_cloud_url = "nsxmanager.corp.vmw"
nsxt_cloud_username = "admin"
nsxt_cloud_password = "VMware1!VMware1!"
nsxt_cloud_prefix = "tf"
cloud_name = "tf-nsxt-cloud"
nsxt_cloud_cred_name = "nsxt-cloud_cred"

# NSX-T Overlay Management Segment
nsxt_cloud_mgmt_tz_name = "nsx-overlay-transportzone"
nsxt_cloud_mgmt_tz_type = "OVERLAY"
nsxt_mgmt_lr_id = "t1-avi"
nsxt_mgmt_segment_id = "avi-mgmt-00"

# NSX-T Data Segment
nsxt_cloud_data_tz_name = "nsx-overlay-transportzone"
nsxt_cloud_data_tz_type = "OVERLAY"
nsxt_cloud_lr1 = "t1-avi"
nsxt_cloud_overlay_seg1 = "avi-mgmt-00"
nsxt_cloud_lr2 = "t1-east"
nsxt_cloud_overlay_seg2 = "ls-tas-deployment-01"

# Other Paramters
data_avi_network_avi_vip_name = "avi-mgmt-00"
