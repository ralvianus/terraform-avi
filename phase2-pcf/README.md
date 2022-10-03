## [`terraform-avi`](../README.md)`/phase2-pcf`
Terraform module for the `avi networks` load-balancing platform to support CloudFoundry environment. The documentation on the design is [here](https://avinetworks.com/docs/22.1/cloud-foundry-load-balancing/)

This lab uses Tanzu Application Service on NSX-T networking. NSX-T Cloud has to be configured in AVI controller prior to this configuration.

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
avi_server	= "avic.corp.vmw"
avi_username	= ""
avi_password	= ""
avi_version	= "21.1.4"
nsxt_cloud_lr1 = "T1-Router-TAS-Deployment"
cloud_name	= "tf-nsxt-cloud"

# NSX-T cloud configuration
nsxt_cloud_url = "nsxmanager.corp.vmw"
nsxt_cloud_username = ""
nsxt_cloud_password = ""

# pcf Virtual Service
vs_http_name	= "pcf-http"
vs_https_name = "pcf-https"
vs_address	= "10.20.10.110"
ca_certs = ""
ca_key = ""
pcf_certs = ""
pcf_key = ""
```
---
