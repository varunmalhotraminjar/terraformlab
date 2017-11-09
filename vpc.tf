# Internet VPC

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags {
    Name = "main"
  }
}

# Public Subnets

resource "aws_subnet" "public-01" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  vpc_id = "${aws_vpc.main.id}"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "public-02" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags{
    Name = "public-02"
  }
}

resource "aws_subnet" "public-03" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = "true"

  tags{
    Name = "public-03"
  }
}

# Private Subnets

resource "aws_subnet" "private-01" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1a"

  tags {
    Name = "Private-01"
  }
}
resource "aws_subnet" "private-02" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1b"

  tags {
    Name = "Private-02"
  }
}
  resource "aws_subnet" "private-03" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1c"

    tags {
      Name = "Private-03"
    }
}
# Internet Gateway

resource "aws_internet_gateway" "main-gw" {
  vpc_id  = "${aws_vpc.main.id}"

  tags {
    Name = "main"
  }
}

# route tables

resource "aws_route_table" "main-public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-gw.id}"
  }
  tags {
    Name = "main-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
    subnet_id = "${aws_subnet.public-01.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}
resource "aws_route_table_association" "main-public-2-a" {
    subnet_id = "${aws_subnet.public-02.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}
resource "aws_route_table_association" "main-public-3-a" {
    subnet_id = "${aws_subnet.public-03.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}
