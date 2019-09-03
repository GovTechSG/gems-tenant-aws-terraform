#-----------------------------------------------------------------------------------------------------------------------
/*
███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗     ██████╗ ██████╗  ██████╗ ██╗   ██╗██████╗ 
██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝    ██╔════╝ ██╔══██╗██╔═══██╗██║   ██║██╔══██╗
███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝     ██║  ███╗██████╔╝██║   ██║██║   ██║██████╔╝
╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝      ██║   ██║██╔══██╗██║   ██║██║   ██║██╔═══╝ 
███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║       ╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║     
╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝        ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝     
                                                                                                             
*/
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Kong_ELB_Gateway" {
  name        = "GEMS_Tenant_Kong_ELB_Gateway"
  description = "Allow traffic from GEMS Tenant Bastion and Kong Gateway ELB"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["129.126.72.14/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_elb_gw"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Kong_ELB_Admin_API" {
  name        = "GEMS_Tenant_Kong_ELB_Admin_API"
  description = "Allow traffic from GEMS Tenant Bastion and Kong Admin API ELB"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["129.126.72.14/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_elb_adm"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Kong_ELB_Manager" {
  name        = "GEMS_Tenant_Kong_ELB_Manager"
  description = "Allow traffic from GEMS Tenant Bastion and Kong Manager ELB"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["129.126.72.14/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_elb_mgr"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Kong_ELB_Dev_Portal" {
  name        = "GEMS_Tenant_Kong_ELB_Dev_Portal"
  description = "Allow traffic from GEMS Tenant Bastion and Kong Dev Portal ELB"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["129.126.72.14/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_elb_dp"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Kong_ELB_Dev_Portal_API" {
  name        = "GEMS_Tenant_Kong_ELB_Dev_Portal_API"
  description = "Allow traffic from GEMS Tenant Bastion and Kong Dev Portal API ELB"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["129.126.72.14/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_elb_dpa"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Bastion" {
  name        = "GEMS_Tenant_Bastion"
  description = "Allow traffic from Kingpin"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["129.126.72.14/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_bastion"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Kong_Gateway" {
  name        = "GEMS_Tenant_Kong_Gateway"
  description = "Allow traffic from GEMS Tenant Bastion and Kong Gateway ELB"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.GEMS_Tenant_Bastion.id}"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    security_groups = ["${aws_security_group.GEMS_Tenant_Kong_ELB_Gateway.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_gw"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Kong_Manager_And_Admin_API" {
  name        = "GEMS_Tenant_Kong_Manager_And_Admin_API"
  description = "Allow traffic from GEMS Tenant Bastion and Kong Manager ELB and Kong Admin API ELB"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.GEMS_Tenant_Bastion.id}"]
  }

  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    security_groups = ["${aws_security_group.GEMS_Tenant_Kong_ELB_Admin_API.id}"]
  }

  ingress {
    from_port   = 8002
    to_port     = 8002 
    protocol    = "tcp"
    security_groups = ["${aws_security_group.GEMS_Tenant_Kong_ELB_Manager.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_mgr_adm"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API" {
  name        = "GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API"
  description = "Allow traffic from GEMS Tenant Bastion and Kong Dev Portal ELB and Kong Dev Portal API ELB"
  vpc_id      = "${aws_vpc.GEMS_Tenant_Staging.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.GEMS_Tenant_Bastion.id}"]
  }

  ingress {
    from_port   = 8003
    to_port     = 8003
    protocol    = "tcp"
    security_groups = ["${aws_security_group.GEMS_Tenant_Kong_ELB_Dev_Portal.id}"]
  }

  ingress {
    from_port   = 8004
    to_port     = 8004
    protocol    = "tcp"
    security_groups = ["${aws_security_group.GEMS_Tenant_Kong_ELB_Dev_Portal_API.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}_sg_dp_dpa"
  }
}