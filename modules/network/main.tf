resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.project_tag}-serverless-rds-vpc"
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Main VPC"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_cidrs)
  cidr_block        = element(var.public_cidrs, count.index)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Public subnet"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Public subnet internet access"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Route table of public subnet to Internet Gateway"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count             = length(var.private_cidrs)
  cidr_block        = element(var.private_cidrs, count.index)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Private subnet"
  }
}

resource "aws_db_subnet_group" "private" {
  name        = "${var.project_tag}-serverless-rds-database-subnet-group"
  description = "Groups private subnets for RDS instance"
  subnet_ids  = aws_subnet.private.*.id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Subnet group for RDS instance"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Route table of private subnet"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_cidrs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# setting default route table of VPC
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.private.id
}
