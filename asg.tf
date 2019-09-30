resource "aws_launch_configuration" "gateway_lc" {
  depends_on = [aws_lb.GEMS-ELB-Gateway]
  name   = "GEMS_Gateway_lc"
  image_id           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.GEMS_Tenant_Kong_Gateway.id}"]
  key_name = "${var.key_name}"

  user_data = <<-EOF
              Content-Type: multipart/mixed; boundary="//"
              MIME-Version: 1.0
              --//
              Content-Type: text/cloud-config; charset="us-ascii"
              MIME-Version: 1.0
              Content-Transfer-Encoding: 7bit
              Content-Disposition: attachment; filename="cloud-config.txt"
              #cloud-config
              cloud_final_modules:
              - [scripts-user, always]
              --//
              Content-Type: text/x-shellscript; charset="us-ascii"
              MIME-Version: 1.0
              Content-Transfer-Encoding: 7bit
              Content-Disposition: attachment; filename="userdata.txt"
              --//
              #! /bin/bash
              yum install -y yum-utils device-mapper-persistent-data lvm2
              yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
              yum install -y docker-ce docker-ce-cli containerd.io
              systemctl enable docker
              systemctl start docker
              docker pull gemsapi/demo
              docker tag gemsapi/demo:latest kong-ee:latest
              export KONG_LICENSE_DATA=${var.portal_license}
              export KONG_ADMIN_GUI_SESSION_CONF=${var.manager_auth_conf}
              export KONG_PORTAL_SESSION_CONF=${var.dev_portal_auth_conf}
              docker run --rm -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_PASSWORD=${var.portal_admin_password}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" kong-ee kong migrations bootstrap
              docker run --rm -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_PASSWORD=${var.portal_admin_password}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" kong-ee kong migrations up
              docker rm -f kong-ee
              docker run -d --name kong-ee --restart always -e "KONG_PORTAL_CORS_ORIGINS=*" -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" -e "KONG_ENFORCE_RBAC=on" -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" -e "KONG_PROXY_ERROR_LOG=/dev/stderr" -e "KONG_PROXY_LISTEN=0.0.0.0:8443, 0.0.0.0:8000 ssl" -p 8000:8000 kong-ee 
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "gateway_asg" {
  depends_on = [aws_lb.GEMS-ELB-Gateway]
  name                 = "GEMS_Gateway_asg"
  launch_configuration = "${aws_launch_configuration.gateway_lc.name}"
  min_size             = 1
  max_size             = 1
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = ["${aws_subnet.az1_pub.id}"]
  target_group_arns  = ["${aws_lb_target_group.GEMS-TG-Gateway.arn}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "GEMS_Gateway_asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "dev_portal_and_api_lc" {
  depends_on = [aws_lb.GEMS-ELB-Dev-Portal,aws_lb.GEMS-ELB-Dev-Portal-API]
  name   = "GEMS_Dev_Portal_and_API_lc"
  image_id           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"]
  key_name = "${var.key_name}"

  user_data = <<-EOF
              Content-Type: multipart/mixed; boundary="//"
              MIME-Version: 1.0
              --//
              Content-Type: text/cloud-config; charset="us-ascii"
              MIME-Version: 1.0
              Content-Transfer-Encoding: 7bit
              Content-Disposition: attachment; filename="cloud-config.txt"
              #cloud-config
              cloud_final_modules:
              - [scripts-user, always]
              --//
              Content-Type: text/x-shellscript; charset="us-ascii"
              MIME-Version: 1.0
              Content-Transfer-Encoding: 7bit
              Content-Disposition: attachment; filename="userdata.txt"
              --//
              #! /bin/bash
              yum install -y yum-utils device-mapper-persistent-data lvm2
              yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
              yum install -y docker-ce docker-ce-cli containerd.io
              systemctl enable docker
              systemctl start docker
              docker pull gemsapi/demo
              docker tag gemsapi/demo:latest kong-ee:latest
              export KONG_LICENSE_DATA=${var.portal_license}
              export KONG_ADMIN_GUI_SESSION_CONF=${var.manager_auth_conf}
              export KONG_PORTAL_SESSION_CONF=${var.dev_portal_auth_conf}
              docker run --rm -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_PASSWORD=${var.portal_admin_password}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" kong-ee kong migrations bootstrap
              docker run --rm -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_PASSWORD=${var.portal_admin_password}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" kong-ee kong migrations up
              docker rm -f kong-ee
              docker run -d --name kong-ee --restart always -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" -e "KONG_ENFORCE_RBAC=on" -e "KONG_AUDIT_LOG=on" -e "KONG_PORTAL_AUTH=basic-auth" -e "KONG_PORTAL=on" -e "KONG_PORTAL_SESSION_CONF=$KONG_PORTAL_SESSION_CONF" -e "KONG_PORTAL_API_LISTEN=0.0.0.0:8004" -e "KONG_PORTAL_GUI_PROTOCOL=https" -e "KONG_PORTAL_GUI_HOST=${var.dev_portal_uri}" -e "KONG_PORTAL_API_URL=https://${var.dev_portal_api_uri}" -e "KONG_PORTAL_API_ACCESS_LOG=/dev/stdout" -e "KONG_PORTAL_API_ERROR_LOG=/dev/stderr" -p 8003-8004:8003-8004 kong-ee
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dev_portal_and_api_asg" {
  depends_on = [aws_lb.GEMS-ELB-Dev-Portal,aws_lb.GEMS-ELB-Dev-Portal-API]
  name                 = "GEMS_Dev_Portal_and_API_asg"
  launch_configuration = "${aws_launch_configuration.dev_portal_and_api_lc.name}"
  min_size             = 1
  max_size             = 1
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = ["${aws_subnet.az1_pub.id}"]
  target_group_arns  = ["${aws_lb_target_group.GEMS-TG-Dev-Portal-API.arn}","${aws_lb_target_group.GEMS-TG-Dev-Portal.arn}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "GEMS_Dev_Portal_and_API_asg"
    propagate_at_launch = true
  }
}