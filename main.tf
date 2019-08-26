provider "aws" {
  region  = "${var.region}"
  access_key =  "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_security_group" "ssh_from_home" {
  name        = "ssh_from_home"
  description = "Allow ssh from ronald home"
  vpc_id      = "${aws_vpc.gems_vpc[0].id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["129.126.74.126/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.gems_tag}"
  }
}

resource "aws_instance" "test" {
  ami           = "${var.aws_ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.ssh_from_home.id}"]
  subnet_id = "${aws_subnet.az1_pub.id}"
  key_name = "awsgems"

  tags = {
    Name = "${var.gems_tag}"
  }

  connection {
    host        = "${aws_instance.test.public_ip}"
    type        = "ssh"
    user        = "centos"
    private_key = "${file("~/.ssh/awsgems.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y yum-utils docker",
      "sudo systemctl start docker",
    ]
  }
}