## [`terraform-avi`](../README.md)`/phase2-pcf`
Terraform module for the `avi networks` load-balancing platform to support CloudFoundry environment. The documentation on the design is [here](https://avinetworks.com/docs/22.1/cloud-foundry-load-balancing/)
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
# avi parameters
avi_server	= "avic.lab01.one"
avi_username	= ""
avi_password	= ""
avi_version	= "21.1.3"
nsxt_cloud_lr1 = "t1-avi"

# pcf Virtual Service
hmon_name = 
cloud_name	= "tf-nsxt-cloud"
vs_name		= "ns1"
vs_fqdn		= "avi-ns1.lb.lab01.one"
vs_address	= "10.20.10.120"
```
---
