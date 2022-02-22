provider "aviatrix" {
  controller_ip = "3.68.43.209"
  username      = var.username
  password      = var.avx_controller_admin_password
}

provider "aws" {
  region = var.aws_region
}


provider "alicloud" {
  # Configuration options
}
provider "azurerm" {
  # credentials passed via TF Cloud ENV
  features {}
}
#=============================================== CHINA ===========================================================

provider "aviatrix" {
  alias         = "china"
  username      = var.china_avx_user
  password      = var.china_avx_pass
  controller_ip = var.china_avx_controller_ip
}

provider "aws" {
  alias  = "china"
  region = var.china_aws_region
  access_key = var.china_aws_access_key_id
  secret_key = var.china_aws_secret_key
}

provider "alicloud" {
  alias  = "china"
  region = var.china_alicloud_region
  # access_key = taken from ENV - ALICLOUD_ACCESS_KEY
  # secret_key = taken from ENV - ALICLOUD_SECRET_KEY
}
