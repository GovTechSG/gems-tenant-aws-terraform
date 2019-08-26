resource "aws_vpc" "gems_vpc" {
  count = "${var.vpc_id == "" ? 1 : 0}"
  cidr_block = "${var.vpc_cidr_ip}.0.0/16"

  tags = {
    Name = "${var.gems_tag}"
  }
}

resource "aws_internet_gateway" "az1_igw" {
  vpc_id     = "${aws_vpc.gems_vpc[0].id}"

  tags = {
    Name = "${var.gems_tag}"
  }
}

resource "aws_subnet" "az1_pub" {
  vpc_id     = "${aws_vpc.gems_vpc[0].id}"
  cidr_block = "${var.vpc_cidr_ip}.10.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.gems_tag}"
  }
}

resource "aws_route_table" "az1_pub_rt" {
    vpc_id = "${aws_vpc.gems_vpc[0].id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.az1_igw.id}"
    }

    tags = {
        Name = "${var.gems_tag}"
    }
}

resource "aws_route_table_association" "az1_pub_rta" {
    subnet_id = "${aws_subnet.az1_pub.id}"
    route_table_id = "${aws_route_table.az1_pub_rt.id}"
}

resource "aws_subnet" "az1_pri" {
  vpc_id     = "${aws_vpc.gems_vpc[0].id}"
  cidr_block = "${var.vpc_cidr_ip}.20.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.gems_tag}"
  }
}