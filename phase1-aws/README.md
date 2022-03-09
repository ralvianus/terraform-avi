## [`terraform-avi`](../README.md)`/phase1-aws`
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

# avi parameters
avi_server		= "avic.lab01.one"
avi_username		= ""
avi_password		= ""
avi_version		= "20.1.6"

# vcenter cloud configuration
cloud_name		= "tf-vmware-cloud"
vcenter_license_tier	= "ENTERPRISE"
vcenter_license_type	= "LIC_CORES"
vcenter_configuration	= {
	username		= ""
	password		= ""
	vcenter_url		= "vcenter.lab01.one"
	datacenter		= "lab01"
	management_network	= "pg-mgmt"
	privilege		= "WRITE_ACCESS"
}
```
---
