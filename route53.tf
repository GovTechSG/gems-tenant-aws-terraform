data "aws_route53_zone" "gemsapi" {
  name         = "gemsapi.io."
}

resource "aws_route53_record" "gateway" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "gateway.${data.aws_route53_zone.gemsapi.name}"
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Gateway.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Gateway.zone_id}"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "adminapi" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "adminapi.${data.aws_route53_zone.gemsapi.name}"
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Admin-API.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Admin-API.zone_id}"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "manager" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "manager.${data.aws_route53_zone.gemsapi.name}"
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Manager.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Manager.zone_id}"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "devportal" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "devportal.${data.aws_route53_zone.gemsapi.name}"
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Dev-Portal.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Dev-Portal.zone_id}"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "devportalapi" {
  zone_id = "${data.aws_route53_zone.gemsapi.zone_id}"
  name    = "devportalapi.${data.aws_route53_zone.gemsapi.name}"
  type    = "A"
  
  alias {
    name                   = "${aws_lb.GEMS-ELB-Dev-Portal-API.dns_name}"
    zone_id                = "${aws_lb.GEMS-ELB-Dev-Portal-API.zone_id}"
    evaluate_target_health = false
  }
}