variable "eu_alicloud_region" {
  type = string
  default = "eu-west-1"
}
variable "controller_ip" {
  type = string
}

variable "avx_username" {
  type    = string
  default = "admin"
}

variable "avx_controller_admin_password" {
  type = string
}

variable "avx_ctrl_account_alicloud" {
  type        = string
  description = "account name of ALI CLOUD defined in EU Controller"
}

variable "avx_ctrl_account_aws" {
  type        = string
  description = "account name of AWS CLOUD defined in EU Controller"
}

variable "avx_ctrl_account_azure" {
  type        = string
  description = "account name of AZURE CLOUD defined in EU Controller"
}
#--------------------------------------------------- CHINA VARs ---------------------------------------
variable "china_alicloud_region" {
  type    = string
  default = "China "
}

variable "china_aws_region" {
  type    = string
  default = "cn-north-1"
}

variable "china_aws_access_key_id" {
  type        = string
  description = "defined as TF_VAR_china_aws_access_key_id in ENV"
}

variable "china_aws_secret_key" {
  type        = string
  description = "defined as TF_VAR_china_aws_secret_key in ENV"
}

variable "avx_ctrl_account_alicloud_china" {
  type        = string
  description = "account name of ALI CLOUD defined in China Controller"
}
variable "avx_ctrl_account_aws_china" {
  type        = string
  description = "account name of ALI CLOUD defined in China Controller"
}

# defined as var in TF Cloud
variable "china_avx_controller_ip" {
  type = string
}
# defined as var in TF Cloud
variable "china_avx_user" {
  type = string
}
# defined as ENV in TF Cloud
variable "china_avx_pass" {
  type = string
}
