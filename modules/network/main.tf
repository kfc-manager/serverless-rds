resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Projects    = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Main VPC"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Public Subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Internet Gateway for Public Subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Route Table for Public Subnet"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Private Subnet"
  }
}

resource "aws_db_subnet_group" "private" {
  name        = "private_subnet_group"
  description = "Group which holds all Private Subnets in the VPC"
  subnet_ids  = aws_subnet.private.*.id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Private Subnet"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Route Table for Private Subnet"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
