# Creation of CEN in Ali
resource "alicloud_cen_instance" "Aviatrix-CEN" {
  cen_instance_name = "ALI_CEN"
  description       = "pkonitz - CEN instance"
  tags = {
      Owner = "pkonitz"
  }
}