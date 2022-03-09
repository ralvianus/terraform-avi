## [`terraform-avi`](../README.md)`/phase2-dns`
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

# dns service
cloud_name	= "tf-vmware-cloud"
vs_name		= "ns1"
vs_fqdn		= "ns1.lb.lab01.one"
vs_address	= "172.16.10.120"

```
---
