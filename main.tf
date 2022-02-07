module "aws_transit" {
  source                        = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version                       = "v4.0.3"
  account                       = var.aws_account_name
  region                        = var.aws_region
  cidr                          = "10.40.0.0/23"
  name                          = "aws-transit-2"
  suffix                        = false
  prefix                        = false
  enable_advertise_transit_cidr = true
  instance_size                 = "c5.4xlarge"
}

resource "aviatrix_transit_external_device_conn" "velo2" {
  vpc_id            = module.aws_transit.vpc.vpc_id
  connection_name   = "velo2"
  gw_name           = module.aws_transit.transit_gateway.gw_name
  connection_type   = "bgp"
  tunnel_protocol   = "LAN"
  bgp_local_as_num  = "65102"
  bgp_remote_as_num = "65022"
  remote_lan_ip     = "10.40.1.46"
  #remote_lan_ip     = aws_network_interface.private_ge3.private_ip
  #ha_enabled               = true
  #backup_bgp_remote_as_num = "65000"
  #backup_remote_lan_ip     = module.csr2.lan_interface.private_ip
  #lifecycle {
  #  ignore_changes = [
  #    ha_enabled
  #  ]
  #}
  


}

data "aws_route_table" "wan" {
  vpc_id = module.aws_transit.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["${module.aws_transit.vpc.name}-Public-rtb"]
  }
  depends_on = [
    module.aws_transit
  ]
}

data "aws_route_table" "lan" {
  vpc_id = module.aws_transit.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["${module.aws_transit.vpc.name}-Private-rtb"]
  }
  depends_on = [
    module.aws_transit
  ]
}

resource "aws_subnet" "wan-a" {
  vpc_id            = module.aws_transit.vpc.vpc_id
  cidr_block        = "10.40.1.0/28"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "WAN-subnet-a"
  }
}

resource "aws_subnet" "wan-b" {
  vpc_id            = module.aws_transit.vpc.vpc_id
  cidr_block        = "10.40.1.16/28"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "WAN-subnet-b"
  }
}

resource "aws_subnet" "lan-a" {
  vpc_id            = module.aws_transit.vpc.vpc_id
  cidr_block        = "10.40.1.32/28"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "LAN-subnet-a"
  }
}

resource "aws_subnet" "lan-b" {
  vpc_id            = module.aws_transit.vpc.vpc_id
  cidr_block        = "10.40.1.48/28"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "LAN-subnet-b"
  }
}

resource "aws_route_table_association" "wan-a" {
  subnet_id      = aws_subnet.wan-a.id
  route_table_id = data.aws_route_table.wan.id
}

resource "aws_route_table_association" "wan-b" {
  subnet_id      = aws_subnet.wan-b.id
  route_table_id = data.aws_route_table.wan.id
}

resource "aws_route_table_association" "lan-a" {
  subnet_id      = aws_subnet.lan-a.id
  route_table_id = data.aws_route_table.lan.id
}

resource "aws_route_table_association" "lan-b" {
  subnet_id      = aws_subnet.lan-b.id
  route_table_id = data.aws_route_table.lan.id
  
}

module "aws-srv" {
  source = "git::https://github.com/fkhademi/terraform-aws-instance-module.git"

  name      = "aws-srv-spoke2"
  region    = var.aws_region
  vpc_id    = module.aws_transit.vpc.vpc_id
  subnet_id = module.aws_transit.vpc.public_subnets[0].subnet_id
  ssh_key   = var.ssh_key
  public_ip = true
}

module "spoke1" {
  source  = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version = "4.0.3"

  name       = "velo2-spoke1"
  cidr       = "10.41.1.0/24"
  region     = var.aws_region
  account    = var.aws_account_name
  transit_gw = module.aws_transit.transit_gateway.gw_name
  prefix     = false
  suffix     = false
  ha_gw      = false

}
