resource "aws_security_group" "outbound" {
  name        = "${var.project_tag}-serverless-rds-egress-database"
  description = "Allows instances with this security group to access the RDS instance"
  vpc_id      = var.vpc_id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Security group for access to database"
  }
}

resource "aws_security_group" "inbound" {
  name        = "${var.project_tag}-serverless-rds-ingress-database"
  description = "Allows instances the RDS instance to be accessed"
  vpc_id      = var.vpc_id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Security group for access to database"
  }
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id            = aws_security_group.outbound.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.inbound.id
}

resource "aws_vpc_security_group_ingress_rule" "inbound" {
  security_group_id            = aws_security_group.inbound.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.outbound.id
}

resource "aws_db_instance" "main" {
  identifier             = "${var.project_tag}-serverless-rds"
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.instance_class
  username               = var.db_username
  password               = var.db_password
  port                   = var.db_port
  skip_final_snapshot    = var.skip_final_snapshot
  db_subnet_group_name   = var.subnet_group_name
  vpc_security_group_ids = [aws_security_group.inbound.id]

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Main database"
  }
}
