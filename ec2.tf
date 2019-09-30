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
  key_name = "${var.key_name}"

  tags = {
    Name = "${var.gems_tag}_ec2_bastion"
  }

}
#-----------------------------------------------------------------------------------------------------------------------
# resource "aws_instance" "GEMS_Tenant_Kong_Gateway" {
#   ami           = "${var.aws_ami_id}"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Kong_Gateway.id}"]
#   subnet_id = "${aws_subnet.az1_pub.id}"
#   key_name = "${var.key_name}"
#   depends_on = [aws_db_instance.GEMS-Tenant-DB]

#   user_data = <<-EOF
#               Content-Type: multipart/mixed; boundary="//"
#               MIME-Version: 1.0
#               --//
#               Content-Type: text/cloud-config; charset="us-ascii"
#               MIME-Version: 1.0
#               Content-Transfer-Encoding: 7bit
#               Content-Disposition: attachment; filename="cloud-config.txt"
#               #cloud-config
#               cloud_final_modules:
#               - [scripts-user, always]
#               --//
#               Content-Type: text/x-shellscript; charset="us-ascii"
#               MIME-Version: 1.0
#               Content-Transfer-Encoding: 7bit
#               Content-Disposition: attachment; filename="userdata.txt"
#               --//
#               #! /bin/bash
#               yum install -y yum-utils device-mapper-persistent-data lvm2
#               yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#               yum install -y docker-ce docker-ce-cli containerd.io
#               systemctl enable docker
#               systemctl start docker
#               docker pull gemsapi/demo
#               docker tag gemsapi/demo:latest kong-ee:latest
#               export KONG_LICENSE_DATA=${var.portal_license}
#               export KONG_ADMIN_GUI_SESSION_CONF=${var.manager_auth_conf}
#               export KONG_PORTAL_SESSION_CONF=${var.dev_portal_auth_conf}
#               docker run --rm -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_PASSWORD=${var.portal_admin_password}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" kong-ee kong migrations bootstrap
#               docker run --rm -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_PASSWORD=${var.portal_admin_password}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" kong-ee kong migrations up
#               docker rm -f kong-ee
#               docker run -d --name kong-ee --restart always -e "KONG_PORTAL_CORS_ORIGINS=*" -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" -e "KONG_ENFORCE_RBAC=on" -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" -e "KONG_PROXY_ERROR_LOG=/dev/stderr" -e "KONG_PROXY_LISTEN=0.0.0.0:8443, 0.0.0.0:8000 ssl" -p 8000:8000 kong-ee 
#               EOF

#   tags = {
#     Name = "${var.gems_tag}_ec2_gw"
#   }
  # connection {
  #     host        = "${aws_instance.GEMS_Tenant_Kong_Gateway.public_ip}"
  #     type        = "ssh"
  #     user        = "centos"
  #     private_key = "${file("${var.path_to_pem_file}")}"
  # }


  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
  #     "sudo yum-config-manager --add-repo https:\\/\\/download.docker.com/linux/centos/docker-ce.repo",
  #     "sudo yum install -y docker-ce docker-ce-cli containerd.io",
  #     "sudo systemctl enable docker",
  #     "sudo systemctl start docker",
  #     "sudo docker pull gemsapi/demo",
  #     "sudo docker tag gemsapi/demo:latest kong-ee:latest",
  #     "export KONG_LICENSE_DATA=${var.portal_license}",
  #     "export KONG_ADMIN_GUI_SESSION_CONF=${var.manager_auth_conf}",
  #     "export KONG_PORTAL_SESSION_CONF=${var.dev_portal_auth_conf}",
  #     "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=${var.portal_admin_password}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations bootstrap",
  #     "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=${var.portal_admin_password}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations up",
  #     "sudo docker rm -f kong-ee",
  #     "sudo docker run -d --name kong-ee --restart always -e \"KONG_PORTAL_CORS_ORIGINS=*\" -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" -e \"KONG_ENFORCE_RBAC=on\" -e \"KONG_PROXY_ACCESS_LOG=/dev/stdout\" -e \"KONG_PROXY_ERROR_LOG=/dev/stderr\" -e \"KONG_PROXY_LISTEN=0.0.0.0:8443, 0.0.0.0:8000 ssl\" -p 8000:8000 kong-ee"
  #   ]
  # }
# }
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "GEMS_Tenant_Kong_Manager_And_Admin_API" {
  ami           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"]
  subnet_id = "${aws_subnet.az1_pub.id}"
  key_name = "${var.key_name}"
  depends_on = [aws_db_instance.GEMS-Tenant-DB]

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
              docker run -d --name kong-ee --restart always -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" -e "KONG_ENFORCE_RBAC=on" -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" -e "KONG_ADMIN_GUI_AUTH=basic-auth" -e "KONG_ADMIN_GUI_SESSION_CONF=$KONG_ADMIN_GUI_SESSION_CONF" -e "KONG_AUDIT_LOG=on" -e "KONG_ADMIN_GUI_URL=https://${var.manager_uri}" -e "KONG_ADMIN_API_URI=https://${var.admin_api_uri}" -e "KONG_PORTAL_AUTH=basic-auth" -e "KONG_PORTAL=on" -e "KONG_PORTAL_SESSION_CONF=$KONG_PORTAL_SESSION_CONF" -e "KONG_PORTAL_GUI_PROTOCOL=https" -e "KONG_PORTAL_GUI_HOST=${var.dev_portal_uri}" -e "KONG_PORTAL_API_URL=https://${var.dev_portal_api_uri}" -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" -p 8001-8002:8001-8002 kong-ee
              while :; do
                curl -sS --fail -o /dev/null -X POST http://localhost:8001/default/services -H 'Content-Type: application/x-www-form-urlencoded' -H 'Kong-Admin-Token: Pass1234' -d 'name=DemoService&protocol=https&host=httpbin.org&port=443' && break
                sleep 1
              done
              while :; do
                curl -sS --fail -o /dev/null -X POST http://localhost:8001/default/services/DemoService/routes -H 'Content-Type: application/x-www-form-urlencoded' -H 'Kong-Admin-Token: Pass1234' -d 'name=DemoRoute&protocols=https&methods=GET&paths[]=/httpbin' && break
                sleep 1
              done
              EOF

  tags = {
    Name = "${var.gems_tag}_ec2_mgr_adm"
  }

  # connection {
  #     host        = "${aws_instance.GEMS_Tenant_Kong_Manager_And_Admin_API.public_ip}"
  #     type        = "ssh"
  #     user        = "centos"
  #     private_key = "${file("${var.path_to_pem_file}")}"
  # }

  # provisioner "file" {
  #   source      = "~/test.sh"
  #   destination = "test.sh"
  # }


  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
  #     "sudo yum-config-manager --add-repo https:\\/\\/download.docker.com/linux/centos/docker-ce.repo",
  #     "sudo yum install -y docker-ce docker-ce-cli containerd.io",
  #     "sudo systemctl enable docker",
  #     "sudo systemctl start docker",
  #     "sudo docker pull gemsapi/demo",
  #     "sudo docker tag gemsapi/demo:latest kong-ee:latest",
  #     "export KONG_LICENSE_DATA=${var.portal_license}",
  #     "export KONG_ADMIN_GUI_SESSION_CONF=${var.manager_auth_conf}",
  #     "export KONG_PORTAL_SESSION_CONF=${var.dev_portal_auth_conf}",
  #     "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=${var.portal_admin_password}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations bootstrap",
  #     "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=${var.portal_admin_password}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations up",
  #     "sudo docker rm -f kong-ee",
  #     "sudo docker run -d --name kong-ee --restart always -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" -e \"KONG_ENFORCE_RBAC=on\" -e \"KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl\" -e \"KONG_ADMIN_GUI_AUTH=basic-auth\" -e \"KONG_ADMIN_GUI_SESSION_CONF=$KONG_ADMIN_GUI_SESSION_CONF\" -e \"KONG_AUDIT_LOG=on\" -e \"KONG_ADMIN_GUI_URL=https://${var.manager_uri}\" -e \"KONG_ADMIN_API_URI=https://${var.admin_api_uri}\" -e \"KONG_PORTAL_AUTH=basic-auth\" -e \"KONG_PORTAL=on\" -e \"KONG_PORTAL_SESSION_CONF=$KONG_PORTAL_SESSION_CONF\" -e \"KONG_PORTAL_GUI_PROTOCOL=https\" -e \"KONG_PORTAL_GUI_HOST=${var.dev_portal_uri}\" -e \"KONG_PORTAL_API_URL=https://${var.dev_portal_api_uri}\" -e \"KONG_ADMIN_ACCESS_LOG=/dev/stdout\" -e \"KONG_ADMIN_ERROR_LOG=/dev/stderr\" -p 8001-8002:8001-8002 kong-ee" 
  #     ]
  # }

}
#-----------------------------------------------------------------------------------------------------------------------
# resource "aws_instance" "GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API" {
#   ami           = "${var.aws_ami_id}"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"]
#   subnet_id = "${aws_subnet.az1_pub.id}"
#   key_name = "${var.key_name}"
#   depends_on = [aws_db_instance.GEMS-Tenant-DB]

#   user_data = <<-EOF
#               Content-Type: multipart/mixed; boundary="//"
#               MIME-Version: 1.0
#               --//
#               Content-Type: text/cloud-config; charset="us-ascii"
#               MIME-Version: 1.0
#               Content-Transfer-Encoding: 7bit
#               Content-Disposition: attachment; filename="cloud-config.txt"
#               #cloud-config
#               cloud_final_modules:
#               - [scripts-user, always]
#               --//
#               Content-Type: text/x-shellscript; charset="us-ascii"
#               MIME-Version: 1.0
#               Content-Transfer-Encoding: 7bit
#               Content-Disposition: attachment; filename="userdata.txt"
#               --//
#               #! /bin/bash
#               yum install -y yum-utils device-mapper-persistent-data lvm2
#               yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#               yum install -y docker-ce docker-ce-cli containerd.io
#               systemctl enable docker
#               systemctl start docker
#               docker pull gemsapi/demo
#               docker tag gemsapi/demo:latest kong-ee:latest
#               export KONG_LICENSE_DATA=${var.portal_license}
#               export KONG_ADMIN_GUI_SESSION_CONF=${var.manager_auth_conf}
#               export KONG_PORTAL_SESSION_CONF=${var.dev_portal_auth_conf}
#               docker run --rm -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_PASSWORD=${var.portal_admin_password}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" kong-ee kong migrations bootstrap
#               docker run --rm -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_PASSWORD=${var.portal_admin_password}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" kong-ee kong migrations up
#               docker rm -f kong-ee
#               docker run -d --name kong-ee --restart always -e "KONG_DATABASE=postgres" -e "KONG_PG_USER=${var.database_admin_username}" -e "KONG_PG_PASSWORD=${var.database_admin_password}" -e "KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}" -e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" -e "KONG_ENFORCE_RBAC=on" -e "KONG_AUDIT_LOG=on" -e "KONG_PORTAL_AUTH=basic-auth" -e "KONG_PORTAL=on" -e "KONG_PORTAL_SESSION_CONF=$KONG_PORTAL_SESSION_CONF" -e "KONG_PORTAL_API_LISTEN=0.0.0.0:8004" -e "KONG_PORTAL_GUI_PROTOCOL=https" -e "KONG_PORTAL_GUI_HOST=${var.dev_portal_uri}" -e "KONG_PORTAL_API_URL=https://${var.dev_portal_api_uri}"  -p 8003-8004:8003-8004 kong-ee
#               EOF

#   tags = {
#     Name = "${var.gems_tag}_ec2_dp_dpa"
#   }
  # connection {
  #     host        = "${aws_instance.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.public_ip}"
  #     type        = "ssh"
  #     user        = "centos"
  #     private_key = "${file("${var.path_to_pem_file}")}"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
  #     "sudo yum-config-manager --add-repo https:\\/\\/download.docker.com/linux/centos/docker-ce.repo",
  #     "sudo yum install -y docker-ce docker-ce-cli containerd.io",
  #     "sudo systemctl enable docker",
  #     "sudo systemctl start docker",
  #     "sudo docker pull gemsapi/demo",
  #     "sudo docker tag gemsapi/demo:latest kong-ee:latest",
  #     "export KONG_LICENSE_DATA=${var.portal_license}",
  #     "export KONG_ADMIN_GUI_SESSION_CONF=${var.manager_auth_conf}",
  #     "export KONG_PORTAL_SESSION_CONF=${var.dev_portal_auth_conf}",
  #     "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=${var.portal_admin_password}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations bootstrap",
  #     "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=${var.portal_admin_password}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations up",
  #     "sudo docker rm -f kong-ee",
  #     "sudo docker run -d --name kong-ee --restart always -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=${var.database_admin_username}\" -e \"KONG_PG_PASSWORD=${var.database_admin_password}\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" -e \"KONG_ENFORCE_RBAC=on\" -e \"KONG_AUDIT_LOG=on\" -e \"KONG_PORTAL_AUTH=basic-auth\" -e \"KONG_PORTAL=on\" -e \"KONG_PORTAL_SESSION_CONF=$KONG_PORTAL_SESSION_CONF\" -e \"KONG_PORTAL_API_LISTEN=0.0.0.0:8004\" -e \"KONG_PORTAL_GUI_PROTOCOL=https\" -e \"KONG_PORTAL_GUI_HOST=${var.dev_portal_uri}\" -e \"KONG_PORTAL_API_URL=https://${var.dev_portal_api_uri}\"  -p 8003-8004:8003-8004 kong-ee"
  #     ]
  # }

# }
#-----------------------------------------------------------------------------------------------------------------------