data "aws_availability_zones" "available" {}

resource "aws_vpc" "bastion_vpc" {
  cidr_block = "${var.Main_CIDR}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = true

  tags {
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
    Name = "${var.VPC_name}"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidrs" {
  vpc_id = "${aws_vpc.bastion_vpc.id}"
  count = "${length(keys(var.Secondary_CIDRs))}"
  cidr_block = "${element(values(var.Secondary_CIDRs), count.index)}"
}

resource "aws_subnet" "priv_subnets" {
  depends_on = ["aws_vpc_ipv4_cidr_block_association.secondary_cidrs"]
  count                   = "${length(var.PrivSubnets)}"
  cidr_block              = "${lookup(var.PrivSubnets[count.index], "cidr")}"
  vpc_id                  = "${aws_vpc.bastion_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${lookup(var.PrivSubnets[count.index], "az")}"

  tags = {
    Name            = "Priv_Subnet${lookup(var.PrivSubnets[count.index], "name")}-${lookup(var.PrivSubnets[count.index], "az")}"
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
    Zone            = "Public"
  }
}

resource "aws_subnet" "pub_subnets" {
  count                   = "${length(var.PubSubnets)}"
  cidr_block              = "${lookup(var.PubSubnets[count.index], "cidr")}"
  vpc_id                  = "${aws_vpc.bastion_vpc.id}"
  availability_zone       = "${lookup(var.PubSubnets[count.index], "az")}"

  tags = {
    Name            = "Pub_Subnet${lookup(var.PubSubnets[count.index], "name")}-${lookup(var.PubSubnets[count.index], "az")}"
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
    Zone            = "Public"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = "${aws_vpc.bastion_vpc.id}"
  depends_on = ["aws_vpc.bastion_vpc"]

  tags {
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = "${aws_vpc.bastion_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_igw.id}"
  }

  tags {
    Name            = "Public_RT"
    Environment     = "${var.PL_ENV}"
    Project         = "Bastion + ASG + EFS"
    Owner           = "Iban Marco - ibanmarco@gmail.com"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
    count           = "${length(var.PubSubnets)}"
    subnet_id       = "${element(aws_subnet.pub_subnets.*.id, count.index)}"
    route_table_id  = "${aws_route_table.pub_rt.id}"
}
