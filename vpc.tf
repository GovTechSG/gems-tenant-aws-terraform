#-----------------------------------------------------------------------------------------------------------------------
/*
██╗   ██╗██████╗  ██████╗
██║   ██║██╔══██╗██╔════╝
██║   ██║██████╔╝██║     
╚██╗ ██╔╝██╔═══╝ ██║     
 ╚████╔╝ ██║     ╚██████╗
  ╚═══╝  ╚═╝      ╚═════╝
                         
*/
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "GEMS_Tenant" {
  cidr_block = "${var.vpc_cidr_ip}.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.gems_tag}_vpc"
  }
}

resource "aws_internet_gateway" "az1_igw" {
  vpc_id     = "${aws_vpc.GEMS_Tenant.id}"

  tags = {
    Name = "${var.gems_tag}_igw"
  }
}

resource "aws_subnet" "az1_pub" {
  vpc_id     = "${aws_vpc.GEMS_Tenant.id}"
  cidr_block = "${var.vpc_cidr_ip}.10.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.gems_tag}_pub1"
  }
}
resource "aws_subnet" "az2_pub" {
  vpc_id     = "${aws_vpc.GEMS_Tenant.id}"
  cidr_block = "${var.vpc_cidr_ip}.30.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.gems_tag}_pub2"
  }
}

resource "aws_route_table" "az1_pub_rt" {
    vpc_id = "${aws_vpc.GEMS_Tenant.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.az1_igw.id}"
    }

    tags = {
        Name = "${var.gems_tag}_pub_rt"
    }
}

resource "aws_route_table_association" "az1_pub_rta" {
    subnet_id = "${aws_subnet.az1_pub.id}"
    route_table_id = "${aws_route_table.az1_pub_rt.id}"
}

resource "aws_route_table_association" "az2_pub_rta" {
    subnet_id = "${aws_subnet.az2_pub.id}"
    route_table_id = "${aws_route_table.az1_pub_rt.id}"
}

resource "aws_subnet" "az1_pri" {
  vpc_id     = "${aws_vpc.GEMS_Tenant.id}"
  cidr_block = "${var.vpc_cidr_ip}.20.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.gems_tag}_pri"
  }
}


resource "aws_route_table" "az1_pri_rt" {
  depends_on = ["aws_nat_gateway.nat_gw"]
    vpc_id = "${aws_vpc.GEMS_Tenant.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
    }

    tags = {
        Name = "${var.gems_tag}_pri_rt"
    }
}

resource "aws_route_table_association" "az1_pri_rta" {
  depends_on = ["aws_route_table.az1_pri_rt"]
    subnet_id = "${aws_subnet.az1_pri.id}"
    route_table_id = "${aws_route_table.az1_pri_rt.id}"
}

resource "aws_eip" "nat_gw_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on = ["aws_internet_gateway.az1_igw","aws_eip.nat_gw_eip","aws_subnet.az1_pub"]
  allocation_id = "${aws_eip.nat_gw_eip.id}"
  subnet_id     = "${aws_subnet.az1_pub.id}"

  tags = {
    Name = "${var.gems_tag}_nat_gw"
  }
}