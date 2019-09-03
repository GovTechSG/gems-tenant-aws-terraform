#-----------------------------------------------------------------------------------------------------------------------

/*
███████╗██╗      █████╗ ███████╗████████╗██╗ ██████╗    ██╗      ██████╗  █████╗ ██████╗     ██████╗  █████╗ ██╗      █████╗ ███╗   ██╗ ██████╗███████╗██████╗ 
██╔════╝██║     ██╔══██╗██╔════╝╚══██╔══╝██║██╔════╝    ██║     ██╔═══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗
█████╗  ██║     ███████║███████╗   ██║   ██║██║         ██║     ██║   ██║███████║██║  ██║    ██████╔╝███████║██║     ███████║██╔██╗ ██║██║     █████╗  ██████╔╝
██╔══╝  ██║     ██╔══██║╚════██║   ██║   ██║██║         ██║     ██║   ██║██╔══██║██║  ██║    ██╔══██╗██╔══██║██║     ██╔══██║██║╚██╗██║██║     ██╔══╝  ██╔══██╗
███████╗███████╗██║  ██║███████║   ██║   ██║╚██████╗    ███████╗╚██████╔╝██║  ██║██████╔╝    ██████╔╝██║  ██║███████╗██║  ██║██║ ╚████║╚██████╗███████╗██║  ██║
╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝     ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝
                                                                                                                                                               
*/
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_elb" "GEMS-Tenant-Kong-ELB-Gateway" {
  name               = "GEMS-Tenant-Kong-ELB-Gateway"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Gateway.id}"]

  listener {
    instance_port     = 8000
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "${var.cert_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.GEMS_Tenant_Kong_Gateway.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.gems_tag}_elb_gw"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_elb" "GEMS-Tenant-Kong-ELB-Admin-API" {
  name               = "GEMS-Tenant-Kong-ELB-Admin-API"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Admin_API.id}"]

  listener {
    instance_port     = 8001
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "${var.cert_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8001/"
    interval            = 30
  }

  instances                   = ["${aws_instance.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.gems_tag}_elb_adm"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_elb" "GEMS-Tenant-Kong-ELB-Manager" {
  name               = "GEMS-Tenant-Kong-ELB-Manager"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Manager.id}"]

  listener {
    instance_port     = 8002
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "${var.cert_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8002/"
    interval            = 30
  }

  instances                   = ["${aws_instance.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.gems_tag}_elb_mgr"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_elb" "GEMS-Tenant-Kong-ELB-Dev-Portal" {
  name               = "GEMS-Tenant-Kong-ELB-Dev-Portal"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Dev_Portal.id}"]

  listener {
    instance_port     = 8003
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "${var.cert_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8003/"
    interval            = 30
  }

  instances                   = ["${aws_instance.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.gems_tag}_elb_dp"
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_elb" "GEMS-Tenant-Kong-ELB-Dev-Prt-API" {
  name               = "GEMS-Tenant-Kong-ELB-Dev-Prt-API"
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Dev_Portal_API.id}"]

  listener {
    instance_port     = 8004
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "${var.cert_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8004/"
    interval            = 30
  }

  instances                   = ["${aws_instance.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.gems_tag}_elb_dpa"
  }
}
