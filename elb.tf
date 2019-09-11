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
# resource "aws_elb" "GEMS-ELB-Gateway" {
#   name               = "GEMS-ELB-Gateway"
#   subnets      = ["${aws_subnet.az1_pub.id}"]
#   security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Gateway.id}"]

#   listener {
#     instance_port     = 8000
#     instance_protocol = "http"
#     lb_port           = 443
#     lb_protocol       = "https"
#     ssl_certificate_id = "${var.cert_id}"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8000/"
#     interval            = 30
#   }

#   instances                   = ["${aws_instance.GEMS_Tenant_Kong_Gateway.id}"]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "${var.gems_tag}_elb_gw"
#   }
# }

resource "aws_lb_target_group" "GEMS-TG-Gateway" {
    name        = "GEMS-TG-Gateway"
    port        = 8000
    protocol    = "HTTPS"
    vpc_id      = "${aws_vpc.GEMS_Tenant.id}"

    tags = {
      Name = "${var.gems_tag}_tg_gw"
    }
}

resource "aws_lb_target_group_attachment" "GEMS-TGA-Gateway" {
    target_group_arn    = "${aws_lb_target_group.GEMS-TG-Gateway.arn}"
    target_id           = "${aws_instance.GEMS_Tenant_Kong_Gateway.id}"
    port                = 8000
}

resource "aws_lb" "GEMS-ELB-Gateway" {
    name                       = "GEMS-ELB-Gateway"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Gateway.id}"] 
    subnets                    = ["${aws_subnet.az1_pub.id}","${aws_subnet.az2_pub.id}"]
    enable_deletion_protection = false

    tags = {
      Name = "${var.gems_tag}_elb_gw"
    }
}

# resource "aws_lb_listener_certificate" "GEMS-Gateway-Cert" {
#     listener_arn         = "${aws_lb_listener.GEMS-Listener-Gateway.arn}"
#     certificate_arn      = "${data.aws_acm_certificate.gemsapi.arn}"
# }

resource "aws_lb_listener" "GEMS-Listener-Gateway" {
    load_balancer_arn   = "${aws_lb.GEMS-ELB-Gateway.arn}"
    port                = 443
    protocol            = "HTTPS"
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    certificate_arn     = "${var.cert_id}"

    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.GEMS-TG-Gateway.arn}"
    }
}
#-----------------------------------------------------------------------------------------------------------------------
# resource "aws_elb" "GEMS-ELB-Admin-API" {
#   name               = "GEMS-ELB-Admin-API"
#   subnets      = ["${aws_subnet.az1_pub.id}"]
#   security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Admin_API.id}"]

#   listener {
#     instance_port     = 8001
#     instance_protocol = "http"
#     lb_port           = 443
#     lb_protocol       = "https"
#     ssl_certificate_id = "${var.cert_id}"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8001/"
#     interval            = 30
#   }

#   instances                   = ["${aws_instance.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "${var.gems_tag}_elb_adm"
#   }
# }

resource "aws_lb_target_group" "GEMS-TG-Admin-API" {
    name        = "GEMS-TG-Admin-API"
    port        = 8001
    protocol    = "HTTP"
    vpc_id      = "${aws_vpc.GEMS_Tenant.id}"

    tags = {
      Name = "${var.gems_tag}_tg_adm"
    }
}

resource "aws_lb_target_group_attachment" "GEMS-TGA-Admin-API" {
    target_group_arn    = "${aws_lb_target_group.GEMS-TG-Admin-API.arn}"
    target_id           = "${aws_instance.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"
    port                = 8001
}

resource "aws_lb" "GEMS-ELB-Admin-API" {
    name                       = "GEMS-ELB-Admin-API"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Admin_API.id}"]
    subnets                    = ["${aws_subnet.az1_pub.id}","${aws_subnet.az2_pub.id}"]
    enable_deletion_protection = false

    tags = {
      Name = "${var.gems_tag}_elb_adm"
    }
}
# resource "aws_lb_listener_certificate" "GEMS-Admin-API-Cert" {
#     listener_arn         = "${aws_lb_listener.GEMS-Listener-Admin-API.arn}"
#     certificate_arn      = "${data.aws_acm_certificate.gemsapi.arn}"
# }

resource "aws_lb_listener" "GEMS-Listener-Admin-API" {
    load_balancer_arn   = "${aws_lb.GEMS-ELB-Admin-API.arn}"
    port                = 443
    protocol            = "HTTPS"
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    certificate_arn     = "${var.cert_id}"

    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.GEMS-TG-Admin-API.arn}"
    }
}
#-----------------------------------------------------------------------------------------------------------------------
# resource "aws_elb" "GEMS-ELB-Manager" {
#   name               = "GEMS-ELB-Manager"
#   subnets      = ["${aws_subnet.az1_pub.id}"]
#   security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Manager.id}"]

#   listener {
#     instance_port     = 8002
#     instance_protocol = "http"
#     lb_port           = 443
#     lb_protocol       = "https"
#     ssl_certificate_id = "${var.cert_id}"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8002/"
#     interval            = 30
#   }

#   instances                   = ["${aws_instance.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "${var.gems_tag}_elb_mgr"
#   }
# }

resource "aws_lb_target_group" "GEMS-TG-Manager" {
    name        = "GEMS-TG-Manager"
    port        = 8002
    protocol    = "HTTP"
    vpc_id      = "${aws_vpc.GEMS_Tenant.id}"

    tags = {
      Name = "${var.gems_tag}_tg_mgr"
    }
}

resource "aws_lb_target_group_attachment" "GEMS-TGA-Manager" {
    target_group_arn    = "${aws_lb_target_group.GEMS-TG-Manager.arn}"
    target_id           = "${aws_instance.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"
    port                = 8002
}

resource "aws_lb" "GEMS-ELB-Manager" {
    name                       = "GEMS-ELB-Manager"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Manager.id}"] 
    subnets                    = ["${aws_subnet.az1_pub.id}","${aws_subnet.az2_pub.id}"]
    enable_deletion_protection = false

    tags = {
      Name = "${var.gems_tag}_elb_mgr"
    }
}

# resource "aws_lb_listener_certificate" "GEMS-Manager-Cert" {
#     listener_arn         = "${aws_lb_listener.GEMS-Listener-Manager.arn}"
#     certificate_arn      = "${data.aws_acm_certificate.gemsapi.arn}"
# }

resource "aws_lb_listener" "GEMS-Listener-Manager" {
    load_balancer_arn   = "${aws_lb.GEMS-ELB-Manager.arn}"
    port                = 443
    protocol            = "HTTPS"
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    certificate_arn     = "${var.cert_id}"

    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.GEMS-TG-Manager.arn}"
    }
}
#-----------------------------------------------------------------------------------------------------------------------
# resource "aws_elb" "GEMS-ELB-Dev-Portal" {
#   name               = "GEMS-ELB-Dev-Portal"
#   subnets      = ["${aws_subnet.az1_pub.id}"]
#   security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Dev_Portal.id}"]

#   listener {
#     instance_port     = 8003
#     instance_protocol = "http"
#     lb_port           = 443
#     lb_protocol       = "https"
#     ssl_certificate_id = "${var.cert_id}"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8003/"
#     interval            = 30
#   }

#   instances                   = ["${aws_instance.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "${var.gems_tag}_elb_dp"
#   }
# }
resource "aws_lb_target_group" "GEMS-TG-Dev-Portal" {
    name        = "GEMS-TG-Dev-Portal"
    port        = 8003
    protocol    = "HTTP"
    vpc_id      = "${aws_vpc.GEMS_Tenant.id}"

    tags = {
      Name = "${var.gems_tag}_tg_dp"
    }
}

resource "aws_lb_target_group_attachment" "GEMS-TGA-Dev-Portal" {
    target_group_arn    = "${aws_lb_target_group.GEMS-TG-Dev-Portal.arn}"
    target_id           = "${aws_instance.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"
    port                = 8003
}

resource "aws_lb" "GEMS-ELB-Dev-Portal" {
    name                       = "GEMS-ELB-Dev-Portal"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Dev_Portal.id}"]
    subnets                    = ["${aws_subnet.az1_pub.id}","${aws_subnet.az2_pub.id}"]
    enable_deletion_protection = false

    tags = {
      Name = "${var.gems_tag}_elb_dp"
    }
}
# resource "aws_lb_listener_certificate" "GEMS-Dev-Portal-Cert" {
#     listener_arn         = "${aws_lb_listener.GEMS-Listener-Dev-Portal.arn}"
#     certificate_arn      = "${data.aws_acm_certificate.gemsapi.arn}"
# }

resource "aws_lb_listener" "GEMS-Listener-Dev-Portal" {
    load_balancer_arn   = "${aws_lb.GEMS-ELB-Dev-Portal.arn}"
    port                = 443
    protocol            = "HTTPS"
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    certificate_arn     = "${var.cert_id}"

    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.GEMS-TG-Dev-Portal.arn}"
    }
}
#-----------------------------------------------------------------------------------------------------------------------
# resource "aws_elb" "GEMS-ELB-Dev-Prt-API" {
#   name               = "GEMS-ELB-Dev-Prt-API"
#   subnets      = ["${aws_subnet.az1_pub.id}"]
#   security_groups =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Dev_Portal_API.id}"]

#   listener {
#     instance_port     = 8004
#     instance_protocol = "http"
#     lb_port           = 443
#     lb_protocol       = "https"
#     ssl_certificate_id = "${var.cert_id}"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:8004/"
#     interval            = 30
#   }

#   instances                   = ["${aws_instance.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "${var.gems_tag}_elb_dpa"
#   }
# }
resource "aws_lb_target_group" "GEMS-TG-Dev-Portal-API" {
    name        = "GEMS-TG-Dev-Portal-API"
    port        = 8004
    protocol    = "HTTP"
    vpc_id      = "${aws_vpc.GEMS_Tenant.id}"

    tags = {
      Name = "${var.gems_tag}_tg_dpa"
    }
}

resource "aws_lb_target_group_attachment" "GEMS-TGA-Dev-Portal-API" {
    target_group_arn    = "${aws_lb_target_group.GEMS-TG-Dev-Portal-API.arn}"
    target_id           = "${aws_instance.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"
    port                = 8004
}

resource "aws_lb" "GEMS-ELB-Dev-Portal-API" {
    name                       = "GEMS-ELB-Dev-Portal-API"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            =  ["${aws_security_group.GEMS_Tenant_Kong_ELB_Dev_Portal.id}"]
    subnets                    = ["${aws_subnet.az1_pub.id}","${aws_subnet.az2_pub.id}"]
    enable_deletion_protection = false

    tags = {
      Name = "${var.gems_tag}_elb_dpa"
    }
}
# resource "aws_lb_listener_certificate" "GEMS-Dev-Portal-API-Cert" {
#     listener_arn         = "${aws_lb_listener.GEMS-Listener-Dev-Portal-API.arn}"
#     certificate_arn      = "${data.aws_acm_certificate.gemsapi.arn}"
# }

resource "aws_lb_listener" "GEMS-Listener-Dev-Portal-API" {
    load_balancer_arn   = "${aws_lb.GEMS-ELB-Dev-Portal-API.arn}"
    port                = 443
    protocol            = "HTTPS"
    ssl_policy          = "ELBSecurityPolicy-2016-08"
    certificate_arn     = "${var.cert_id}"

    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.GEMS-TG-Dev-Portal-API.arn}"
    }
}
#-----------------------------------------------------------------------------------------------------------------------