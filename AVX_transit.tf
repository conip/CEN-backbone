#---------------------------------------------------------- CHINA ----------------------------------------------------------
module "ali_transit_1" {
  providers = {
    aviatrix = aviatrix.china
  }
source = "github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit"
  # version = "1.1.0"

  cloud = "ali"
  region = "China (Beijing)"
  cidr     = "10.22.0.0/23"
  account  = var.avx_ctrl_account_alicloud_china
  bgp_ecmp = true
  tags = {
    Owner = "pkonitz"
  }
}
