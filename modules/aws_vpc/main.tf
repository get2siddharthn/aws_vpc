
/****
  VPC
****/
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
  }
}

/****
  InternetGW
****/
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.env}-igw"
    Environment = var.env
  }
}

/****
  Elastic-IP (eip) for NAT
****/
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

/****
  NAT
****/
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name        = "${var.env}-nat"
    Environment = "${var.env}"
  }
}

/****
  Public subnet
****/
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.pub_subnet)
  cidr_block              = element(var.pub_subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.env}-${element(var.azs, count.index)}-public-subnet"
    Environment = "${var.env}"
  }
}

/****
  Private subnet
****/
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.prv_subnet)
  cidr_block              = element(var.prv_subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.env}-${element(var.azs, count.index)}-private-subnet"
    Environment = "${var.env}"
  }
}

/****
  Routing tables to route traffic for Private Subnet
****/
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.env}-private-route-table"
    Environment = "${var.env}"
  }
}

/****
  Routing tables to route traffic for Public Subnet
****/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.env}-public-route-table"
    Environment = "${var.env}"
  }
}

/****
  Route for Internet Gateway
****/
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

/****
  Route for NAT
****/
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/****
  Route table associations for both Public & Private Subnets
****/
resource "aws_route_table_association" "public" {
  count          = length(var.pub_subnet)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.prv_subnet)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

/****
  Default Security Group of VPC
****/
resource "aws_security_group" "default" {
  name        = "${var.env}-default-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = "${var.env}"
  }
}
