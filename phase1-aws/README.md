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
# AWS key
aws_access_key = ""
aws_secret_key = ""

# AWS Networking
create_networking = "true"
avi_cidr_block = "10.154.0.0/16"
create_iam = "true"
custom_vpc_id = ""
custom_subnet_ids = [""]
key_pair_name = ""
private_key_path = ""

# AVI Parameters
avi_version = "21.1.3"
controller_password = ""
name_prefix = ""
controller_ha = "false"
controller_public_address = "true"
configure_dns_profile = "true"
configure_dns_vs = "true"
```
---
