## [`terraform-avi`](../README.md)`/phase1-nsxt-cloud`
Terraform module for the `avi networks` load-balancing platform  
Clone repository and adjust `terraform.tfvars` and `main.tf` as required  

---

#### `run`
```
terraform init
terraform plan
terraform apply
```

#### `destroy` [optional]
```
terraform destroy
```

#### `terraform.tfvars`
```
# vsphere  parameters
vcenter_server		= "vcenter.lab01.one"
vcenter_username	= ""
vcenter_password	= ""
datacenter		= "lab01"
datastore	= "vsanDatastore"
content_library_name = "avi-cl"
nsxt_cloud_vcenter_name = "vcsa"
vcsa_cred_name = "vcsa-cred"

# avi parameters
avi_server		= "avic.lab01.one"
avi_username		= ""
avi_password		= ""
avi_version		= "21.1.3"
tenant = "admin"

# NSX-T cloud configuration
nsxt_cloud_url = "172.16.10.117"
nsxt_cloud_username = ""
nsxt_cloud_password = ""
nsxt_cloud_prefix = "tf"
cloud_name = "tf-nsxt-cloud"
nsxt_cloud_cred_name = "nsxt-cloud_cred"

# NSX-T Overlay Management Segment
nsxt_cloud_mgmt_tz_name = "tz-host-overlay"
nsxt_cloud_mgmt_tz_type = "OVERLAY"
nsxt_mgmt_lr_id = "t1-avi"
nsxt_mgmt_segment_id = "avi-mgmt-00"

# NSX-T Data Segment
nsxt_cloud_data_tz_name = "tz-host-overlay"
nsxt_cloud_data_tz_type = "OVERLAY"
nsxt_cloud_lr1 = "t1-avi"
nsxt_cloud_overlay_seg1 = "avi-mgmt-00"
nsxt_cloud_lr2 = "t1-east"
nsxt_cloud_overlay_seg2 = "ocp-east-00"
nsxt_cloud_lr3 = "t1-west"
nsxt_cloud_overlay_seg3 = "ocp-west-00"

# Other Paramters
data_avi_network_avi_vip_name = "avi-mgmt-00"
```
---
