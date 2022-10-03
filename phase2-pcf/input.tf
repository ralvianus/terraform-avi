# avi parameters
variable "avi_server"	{}
variable "avi_username"	{}
variable "avi_password"	{}
variable "avi_version"	{}
variable "nsxt_cloud_lr1"	{}
variable "cloud_name"	{}

# NSX-T cloud configuration
variable "nsxt_cloud_url" {
  type    = string
}
variable "nsxt_cloud_username" {
  type    = string
}
variable "nsxt_cloud_password" {
  type    = string
}

# pcf certificate


# pcf Virtual Service
variable "vs_http_name"	{}
variable "vs_https_name"	{}
variable "vs_address"	{}
variable "ca_certs"	{}
variable "ca_key"	{}
variable "pcf_certs"	{}
variable "pcf_key"	{}
