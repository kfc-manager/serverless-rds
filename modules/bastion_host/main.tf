data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "main" {
  name        = "${var.project_tag}-serverless-rds-bastion-host"
  description = "Allow SSH tunnel connection to bastion host"
  vpc_id      = var.vpc_id

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "SSH access to bastion host"
  }
}

resource "aws_vpc_security_group_ingress_rule" "main" {
  count             = length(var.allowed_ip_addresses)
  security_group_id = aws_security_group.main.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = element(var.allowed_ip_addresses, count.index)
}

resource "aws_network_interface" "main" {
  subnet_id       = var.subnet_id
  security_groups = [var.db_security_group_id, aws_security_group.main.id]


  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Network interface of bastion host"
  }
}

resource "aws_eip" "main" {
  domain            = "vpc"
  network_interface = aws_network_interface.main.id
}

resource "aws_key_pair" "main" {
  key_name   = "${var.project_tag}serverless-rds-bastion-host-key"
  public_key = var.public_ssh_key
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.main.id

  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }

  tags = {
    Project     = var.project
    Environment = var.env
    Type        = "Serverless RDS"
    Description = "Bastion host as entrypoint to database from public internet"
  }
}
