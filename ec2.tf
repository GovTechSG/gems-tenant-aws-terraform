#-----------------------------------------------------------------------------------------------------------------------
/*
███████╗ ██████╗██████╗ 
██╔════╝██╔════╝╚════██╗
█████╗  ██║      █████╔╝
██╔══╝  ██║     ██╔═══╝ 
███████╗╚██████╗███████╗
╚══════╝ ╚═════╝╚══════╝
                        
*/
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "GEMS_Tenant_Bastion" {
  ami           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Bastion.id}"]
  subnet_id = "${aws_subnet.az1_pub.id}"
  key_name = "awsgems"

  tags = {
    Name = "${var.gems_tag}_ec2_bastion"
  }

}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "GEMS_Tenant_Kong_Gateway" {
  ami           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Kong_Gateway.id}"]
  subnet_id = "${aws_subnet.az1_pub.id}"
  key_name = "awsgems"

  tags = {
    Name = "${var.gems_tag}_ec2_gw"
  }

}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "GEMS_Tenant_Kong_Manager_And_Admin_API" {
  ami           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"]
  subnet_id = "${aws_subnet.az1_pub.id}"
  key_name = "awsgems"

  tags = {
    Name = "${var.gems_tag}_ec2_mgr_adm"
  }

}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API" {
  ami           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"]
  subnet_id = "${aws_subnet.az1_pub.id}"
  key_name = "awsgems"

  tags = {
    Name = "${var.gems_tag}_ec2_dp_dpa"
  }

}
#-----------------------------------------------------------------------------------------------------------------------