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
  depends_on = [aws_db_instance.GEMS-Tenant-DB]

  tags = {
    Name = "${var.gems_tag}_ec2_gw"
  }
  connection {
      host        = "${aws_instance.GEMS_Tenant_Kong_Gateway.public_ip}"
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/awsgems.pem")}"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
      "sudo yum-config-manager --add-repo https:\\/\\/download.docker.com/linux/centos/docker-ce.repo",
      "sudo yum install -y docker-ce docker-ce-cli containerd.io",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo docker pull gemsapi/demo",
      "sudo docker tag gemsapi/demo:latest kong-ee:latest",
      "export KONG_LICENSE_DATA='{\"license\":{\"signature\":\"200b7ce3879831fb8f9ccbdbc72f05aeea1ace05dd6d1643765ef77e221ac1f87accb9ff4ab8ffa2c88b28b95569bf4cd7706ef0f7ea258a55056f929e5b7583\",\"payload\":{\"customer\":\"Govtech_Eval\",\"license_creation_date\":\"2019-07-30\",\"product_subscription\":\"Kong Enterprise Edition\",\"admin_seats\":\"5\",\"support_plan\":\"None\",\"license_expiration_date\":\"2019-08-31\",\"license_key\":\"0011K000029bt6rQAA_a1V1K000007JuyDUAS\"},\"version\":1}}'",
      "export KONG_ADMIN_GUI_SESSION_CONF='{\"cookie_name\":\"04tm34l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'",
      "export KONG_PORTAL_SESSION_CONF='{\"cookie_name\":\"04tm35l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'",
      "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=Pass1234\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations bootstrap",
      "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=Pass1234\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations up",
      "sudo docker rm -f kong-ee",
      "sudo docker run -d --name kong-ee --restart always -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" -e \"KONG_PROXY_ACCESS_LOG=/dev/stdout\" -e \"KONG_PROXY_ERROR_LOG=/dev/stderr\" -e \"KONG_PROXY_LISTEN=0.0.0.0:8443, 0.0.0.0:8000 ssl\" -p 8000:8000 kong-ee"
    ]
  }
}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "GEMS_Tenant_Kong_Manager_And_Admin_API" {
  ami           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Kong_Manager_And_Admin_API.id}"]
  subnet_id = "${aws_subnet.az1_pub.id}"
  key_name = "awsgems"
  depends_on = [aws_db_instance.GEMS-Tenant-DB]

  tags = {
    Name = "${var.gems_tag}_ec2_mgr_adm"
  }

  connection {
      host        = "${aws_instance.GEMS_Tenant_Kong_Manager_And_Admin_API.public_ip}"
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/awsgems.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
      "sudo yum-config-manager --add-repo https:\\/\\/download.docker.com/linux/centos/docker-ce.repo",
      "sudo yum install -y docker-ce docker-ce-cli containerd.io",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo docker pull gemsapi/demo",
      "sudo docker tag gemsapi/demo:latest kong-ee:latest",
      "export KONG_LICENSE_DATA='{\"license\":{\"signature\":\"200b7ce3879831fb8f9ccbdbc72f05aeea1ace05dd6d1643765ef77e221ac1f87accb9ff4ab8ffa2c88b28b95569bf4cd7706ef0f7ea258a55056f929e5b7583\",\"payload\":{\"customer\":\"Govtech_Eval\",\"license_creation_date\":\"2019-07-30\",\"product_subscription\":\"Kong Enterprise Edition\",\"admin_seats\":\"5\",\"support_plan\":\"None\",\"license_expiration_date\":\"2019-08-31\",\"license_key\":\"0011K000029bt6rQAA_a1V1K000007JuyDUAS\"},\"version\":1}}'",
      "export KONG_ADMIN_GUI_SESSION_CONF='{\"cookie_name\":\"04tm34l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'",
      "export KONG_PORTAL_SESSION_CONF='{\"cookie_name\":\"04tm35l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'",
      "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=Pass1234\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations bootstrap",
      "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=Pass1234\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations up",
      "sudo docker rm -f kong-ee",
      "sudo docker run -d --name kong-ee --restart always -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" -e \"KONG_ENFORCE_RBAC=on\" -e \"KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl\" -e \"KONG_ADMIN_GUI_AUTH=basic-auth\" -e \"KONG_ADMIN_GUI_SESSION_CONF=$KONG_ADMIN_GUI_SESSION_CONF\" -e \"KONG_AUDIT_LOG=on\" -e \"KONG_ADMIN_GUI_URL=https:\\/\\/manager.gemsapi.io\" -e \"KONG_ADMIN_API_URI=https:\\/\\/adminapi.gemsapi.io\" -e \"KONG_PORTAL=on\" -e \"KONG_PORTAL_GUI_PROTOCOL=https\" -e \"KONG_PORTAL_GUI_HOST=devportal.gemsapi.io\" -e \"KONG_PORTAL_API_URL=httpsz:\\/\\/devportalapi.gemsapi.io\" -e \"KONG_ADMIN_ACCESS_LOG=/dev/stdout\" -e \"KONG_ADMIN_ERROR_LOG=/dev/stderr\" -p 8001-8002:8001-8002 kong-ee"
    ]
  }

}
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API" {
  ami           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.id}"]
  subnet_id = "${aws_subnet.az1_pub.id}"
  key_name = "awsgems"
  depends_on = [aws_db_instance.GEMS-Tenant-DB]

  tags = {
    Name = "${var.gems_tag}_ec2_dp_dpa"
  }
  connection {
      host        = "${aws_instance.GEMS_Tenant_Kong_Dev_Portal_And_Dev_Portal_API.public_ip}"
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/awsgems.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y yum-utils device-mapper-persistent-data lvm2",
      "sudo yum-config-manager --add-repo https:\\/\\/download.docker.com/linux/centos/docker-ce.repo",
      "sudo yum install -y docker-ce docker-ce-cli containerd.io",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo docker pull gemsapi/demo",
      "sudo docker tag gemsapi/demo:latest kong-ee:latest",
      "export KONG_LICENSE_DATA='{\"license\":{\"signature\":\"200b7ce3879831fb8f9ccbdbc72f05aeea1ace05dd6d1643765ef77e221ac1f87accb9ff4ab8ffa2c88b28b95569bf4cd7706ef0f7ea258a55056f929e5b7583\",\"payload\":{\"customer\":\"Govtech_Eval\",\"license_creation_date\":\"2019-07-30\",\"product_subscription\":\"Kong Enterprise Edition\",\"admin_seats\":\"5\",\"support_plan\":\"None\",\"license_expiration_date\":\"2019-08-31\",\"license_key\":\"0011K000029bt6rQAA_a1V1K000007JuyDUAS\"},\"version\":1}}'",
      "export KONG_ADMIN_GUI_SESSION_CONF='{\"cookie_name\":\"04tm34l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'",
      "export KONG_PORTAL_SESSION_CONF='{\"cookie_name\":\"04tm35l\",\"secret\":\"nothing\",\"storage\":\"kong\",\"cookie_secure\":false,\"cookie_samesite\":\"off\",\"cookie_lifetime\":21600}'",
      "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=Pass1234\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations bootstrap",
      "sudo docker run --rm -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PASSWORD=Pass1234\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" kong-ee kong migrations up",
      "sudo docker rm -f kong-ee",
      "sudo docker run -d --name kong-ee --restart always -e \"KONG_DATABASE=postgres\" -e \"KONG_PG_USER=postgres\" -e \"KONG_PG_PASSWORD=Pass1234\" -e \"KONG_PG_HOST=${aws_db_instance.GEMS-Tenant-DB.address}\" -e \"KONG_PORTAL_GUI_PROTOCOL=https\" -e \"KONG_LICENSE_DATA=$KONG_LICENSE_DATA\" -e \"KONG_ENFORCE_RBAC=on\" -e \"KONG_PORTAL_AUTH=basic-auth\" -e \"KONG_PORTAL=on\" -e \"KONG_PORTAL_SESSION_CONF=$KONG_PORTAL_SESSION_CONF\" -e \"KONG_AUDIT_LOG=on\" -e \"KONG_PORTAL_GUI_HOST=devportal.gemsapi.io\" -e \"KONG_PORTAL_API_URL=https:\\/\\/devportalapi.gemsapi.io\" -p 8003-8004:8003-8004 kong-ee"
    ]
  }

}
#-----------------------------------------------------------------------------------------------------------------------