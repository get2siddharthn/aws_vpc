#create VPC
resource "aws_vpc" "terra_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terra_vpc"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "terra_ig" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "terra_ig"
  }
}

#EIP_1
resource "aws_eip" "terra_eip_1" {
  vpc        = true
  depends_on = [aws_internet_gateway.terra_ig]
}

#EIP_2
resource "aws_eip" "terra_eip_2" {
  vpc        = true
  depends_on = [aws_internet_gateway.terra_ig]
}

#EIP_3
resource "aws_eip" "terra_eip_3" {
  vpc        = true
  depends_on = [aws_internet_gateway.terra_ig]
}

#NAT Gateway_1
resource "aws_nat_gateway" "terra_nat_1" {
  allocation_id = aws_eip.terra_eip_1.id
  subnet_id     = aws_subnet.terra_prvsub_1.id

  tags = {
    Name = "terra_nat_1"
  }
}

#NAT Gateway_2
resource "aws_nat_gateway" "terra_nat_2" {
  allocation_id = aws_eip.terra_eip_2.id
  subnet_id     = aws_subnet.terra_prvsub_2.id

  tags = {
    Name = "terra_nat_2"
  }
}

#NAT Gateway_3
resource "aws_nat_gateway" "terra_nat_3" {
  allocation_id = aws_eip.terra_eip_3.id
  subnet_id     = aws_subnet.terra_prvsub_3.id

  tags = {
    Name = "terra_nat_3"
  }
}

#Public subnet -1
resource "aws_subnet" "terra_pubsub_1" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.pub_subnet[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_subent_1"
  }
}

#Public subnet -2
resource "aws_subnet" "terra_pubsub_2" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.pub_subnet[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_subent_2"
  }
}

#Public subnet -3
resource "aws_subnet" "terra_pubsub_3" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.pub_subnet[2]
  availability_zone       = var.azs[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_subent_3"
  }
}

#Private subnet_1
resource "aws_subnet" "terra_prvsub_1" {
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = var.prv_subnet[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "Private_subent_1"
  }
}

#Private subnet_2
resource "aws_subnet" "terra_prvsub_2" {
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = var.prv_subnet[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "Private_subent_2"
  }
}

#Private subnet_3
resource "aws_subnet" "terra_prvsub_3" {
  vpc_id            = aws_vpc.terra_vpc.id
  cidr_block        = var.prv_subnet[2]
  availability_zone = var.azs[2]

  tags = {
    Name = "Private_subent_3"
  }
}

#Public RT
resource "aws_route_table" "pub_rT" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "terra_pub_rT"
    Role = "public"
  }
}

#Private RT
resource "aws_route_table" "prv_rT" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "terra_prv_rT"
    Role = "private"
  }
}

#public route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.pub_rT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terra_ig.id
}

#private route
resource "aws_route" "private" {
  route_table_id         = aws_route_table.prv_rT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.terra_nat_1.id
}

#public rt associateion 1
resource "aws_route_table_association" "pub_associate_1" {
  subnet_id      = aws_subnet.terra_pubsub_1.id
  route_table_id = aws_route_table.pub_rT.id
}

#public rt associateion 2
resource "aws_route_table_association" "pub_associate_2" {
  subnet_id      = aws_subnet.terra_pubsub_2.id
  route_table_id = aws_route_table.pub_rT.id
}

#public rt associateion 3
resource "aws_route_table_association" "pub_associate_3" {
  subnet_id      = aws_subnet.terra_pubsub_3.id
  route_table_id = aws_route_table.pub_rT.id
}

#private rt associateion 1
resource "aws_route_table_association" "prv_associate_1" {
  subnet_id      = aws_subnet.terra_prvsub_1.id
  route_table_id = aws_route_table.prv_rT.id
}

#private rt associateion 2
resource "aws_route_table_association" "prv_associate_2" {
  subnet_id      = aws_subnet.terra_prvsub_2.id
  route_table_id = aws_route_table.prv_rT.id
}

#private rt associateion 3
resource "aws_route_table_association" "prv_associate_3" {
  subnet_id      = aws_subnet.terra_prvsub_3.id
  route_table_id = aws_route_table.prv_rT.id
}
