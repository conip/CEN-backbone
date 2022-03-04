# Creation of CEN in Ali
resource "alicloud_cen_instance" "Aviatrix-CEN" {
  cen_instance_name = "ALI_CEN"
  description       = "pkonitz - CEN instance"
  tags = {
      Owner = "pkonitz"
  }
}

#Attach Ali VPCs to CEN - the CEN seems to be the equivalent to an AWS TGW
resource "alicloud_cen_instance_attachment" "Tranist-europe-attachment" {
  child_instance_id        = module.ali_transit_eu_1.vpc.vpc_id
  child_instance_region_id = "eu-west-1"
  child_instance_type      = "VPC"
  instance_id              = alicloud_cen_instance.Aviatrix-CEN.id
  depends_on = [alicloud_cen_instance.Aviatrix-CEN, module.ali_transit_eu_1]
}

resource "alicloud_cen_instance_attachment" "Transit-beijing-Attachment" {
  instance_id              = alicloud_cen_instance.Aviatrix-CEN.id
  child_instance_id        = module.ali_transit_cn_1.vpc.vpc_id
  child_instance_type      = "VPC"
  child_instance_region_id = "cn-beijing"
  depends_on = [alicloud_cen_instance.Aviatrix-CEN, module.ali_transit_cn_1]
}
