data "aws_route53_zone" "gemsapi" {
  name         = "gemsapi.io."
}

resource "aws_route53_record" "gateway" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "${var.gateway_uri}."
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Gateway.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Gateway.zone_id}"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "adminapi" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "${var.admin_api_uri}."
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Admin-API.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Admin-API.zone_id}"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "manager" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "${var.manager_uri}."
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Manager.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Manager.zone_id}"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "devportal" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "${var.dev_portal_uri}."
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Dev-Portal.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Dev-Portal.zone_id}"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "devportalapi" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "${var.dev_portal_api_uri}."
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Dev-Portal-API.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Dev-Portal-API.zone_id}"
    evaluate_target_health = false
  }
}