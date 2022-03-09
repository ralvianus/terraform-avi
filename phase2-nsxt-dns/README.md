## [`terraform-avi`](../README.md)`/phase2-nsxt-dns`
Terraform module for the `avi networks` load-balancing platform  
Clone repository and adjust `terraform.tfvars` and `main.tf` as required  

---

#### `run`
```
terraform init
terraform plan
terraform apply
```

**Note: After completing this `plan` you must login and enable `Administration > Settings > DNS Service`**

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

# dns service
cloud_name	= "tf-nsxt-cloud"
vs_name		= "ns1"
vs_fqdn		= "avi-ns1.lb.lab01.one"
vs_address	= "10.20.10.120"
```
---
