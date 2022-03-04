#---------------------------------------------------------- EUROPE ----------------------------------------------------------
module "ali_transit_eu_1" {
  source          = "terraform-aviatrix-modules/mc-transit/aviatrix"
  cloud           = "ali"
  name            = "ali-uk"
  region          = "acs-eu-west-1 (London)"
  cidr            = "10.121.0.0/23"
  account         = var.avx_ctrl_account_alicloud
  local_as_number = "65101"
}

module "aws_transit_eu_1" {
  source          = "terraform-aviatrix-modules/mc-transit/aviatrix"
  name            = "aws-trans-eu-1"
  cloud           = "aws"
  region          = "eu-central-1"
  cidr            = "10.111.0.0/23"
  account         = var.avx_ctrl_account_aws
  bgp_ecmp        = true
  local_as_number = "65102"
  tags = {
    Owner = "pkonitz"
  }

}


resource "aviatrix_transit_gateway_peering" "peering_ali1_aws1" {
  transit_gateway_name1 = module.aws_transit_eu_1.transit_gateway.gw_name
  transit_gateway_name2 = module.ali_transit_eu_1.transit_gateway.gw_name
}

# module "transit-peering-eu-2" {
#   source           = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
#   transit_gateways = [module.ali_transit_eu_1.transit_gateway.gw_name, module.aws_transit_eu_1.transit_gateway.gw_name]
#   depends_on       = [module.ali_transit_eu_1, module.aws_transit_eu_1]
# }


#---------------------------------------------------------- CHINA ----------------------------------------------------------
module "ali_transit_cn_1" {
  providers = {
    aviatrix = aviatrix.china
  }
  source          = "github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit"
  name            = "ali-trans-cn-1"
  cloud           = "ali"
  region          = "acs-cn-beijing (Beijing)"
  cidr            = "10.221.0.0/23"
  account         = var.avx_ctrl_account_alicloud_china
  bgp_ecmp        = true
  local_as_number = "65201"

}

module "aws_transit_cn_1" {
  providers = {
    aviatrix = aviatrix.china
  }
  source          = "github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-transit"
  name            = "aws-trans-cn-1"
  cloud           = "aws"
  region          = "cn-north-1"
  cidr            = "10.211.0.0/23"
  account         = var.avx_ctrl_account_aws_china
  bgp_ecmp        = true
  local_as_number = "65202"
  tags = {
    Owner = "pkonitz"
  }

}

module "transit-peering-cn-1" {
  providers = {
    aviatrix = aviatrix.china
  }
  source           = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  transit_gateways = [module.aws_transit_cn_1.transit_gateway.gw_name, module.ali_transit_cn_1.transit_gateway.gw_name]
  depends_on       = [module.aws_transit_cn_1, module.ali_transit_cn_1]
}





resource "aviatrix_transit_external_device_conn" "Alibaba-UK-to-CN-CEN" {
  vpc_id                    = module.ali_transit_eu_1.vpc.vpc_id
  connection_name           = "Alibaba-Frankfurt-to-beijing-CEN"
  gw_name                   = module.ali_transit_eu_1.transit_gateway.gw_name
  connection_type           = "bgp"
  direct_connect            = true
  backup_direct_connect     = true
  remote_gateway_ip         = module.ali_transit_cn_1.transit_gateway.private_ip
  backup_remote_gateway_ip  = module.ali_transit_cn_1.transit_gateway.ha_private_ip
  bgp_local_as_num          = "65101"
  bgp_remote_as_num         = "65201"
  backup_bgp_remote_as_num  = "65201"
  pre_shared_key            = "testtest"
  backup_pre_shared_key     = "testtest"
  local_tunnel_cidr         = "169.254.160.65/30,169.254.160.69/30"
  remote_tunnel_cidr        = "169.254.160.66/30,169.254.160.70/30"
  backup_local_tunnel_cidr  = "169.254.160.73/30,169.254.160.77/30"
  backup_remote_tunnel_cidr = "169.254.160.74/30,169.254.160.78/30"
  ha_enabled                = true
}


resource "aviatrix_transit_external_device_conn" "Alibaba-CN-to-UK-CEN" {
  provider                  = aviatrix.china
  vpc_id                    = module.ali_transit_cn_1.vpc.vpc_id
  connection_name           = "Alibaba-beijing-to-Frankfurt-CEN"
  gw_name                   = module.ali_transit_cn_1.transit_gateway.gw_name
  connection_type           = "bgp"
  direct_connect            = true
  backup_direct_connect     = true
  remote_gateway_ip         = module.ali_transit_eu_1.transit_gateway.private_ip
  backup_remote_gateway_ip  = module.ali_transit_eu_1.transit_gateway.ha_private_ip
  bgp_local_as_num          = "65201"
  bgp_remote_as_num         = "65101"
  backup_bgp_remote_as_num  = "65101"
  pre_shared_key            = "testtest"
  backup_pre_shared_key     = "testtest"
  local_tunnel_cidr         = "169.254.160.66/30,169.254.160.74/30"
  remote_tunnel_cidr        = "169.254.160.65/30,169.254.160.73/30"
  backup_local_tunnel_cidr  = "169.254.160.70/30,169.254.160.78/30"
  backup_remote_tunnel_cidr = "169.254.160.69/30,169.254.160.77/30"
  ha_enabled                = true
}
