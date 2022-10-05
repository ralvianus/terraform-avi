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

# pcf Virtual Service
variable "vs_name"	{}
variable "vs_https_name"	{}
variable "vs_ssh_name"	{}
variable "vs_address"	{}
