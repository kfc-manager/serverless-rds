resource "aws_security_group" "to_database" {
  name        = "Outbound RDS Security Group"
  description = "Allow Instances with this Security Group access to the Database"
  vpc_id      = var.vpc_id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Security Group for access to Database"
  }
}

resource "aws_security_group" "from_database" {
  name        = "Inbound RDS Security Group"
  description = "Allows the RDS Instances to be accessed"
  vpc_id      = var.vpc_id

  tags = {
    Project      = var.project
    Environment  = var.env
    Type         = "Serverless RDS"
    Dsescription = "Security Group for access to Database"
  }
}

resource "aws_vpc_security_group_egress_rule" "to_database" {
  security_group_id            = aws_security_group.to_database.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.from_database.id
}

resource "aws_vpc_security_group_ingress_rule" "from_database" {
  security_group_id            = aws_security_group.from_database.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.to_database.id
}

resource "aws_db_instance" "main" {
  identifier             = var.identifier
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.instance_class
  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port
  skip_final_snapshot    = var.skip_final_snapshot
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.from_database.id]

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Main Database"
  }
}
