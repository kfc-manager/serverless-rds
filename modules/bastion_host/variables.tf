variable "subnet_id" {
  description = "Subnet ID of the EC2 Instance"
  type        = string
}

variable "db_security_group_id" {
  description = "ID of the Security Group to access the Database"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "instance_type" {
  description = "Instance class of the EC2 Instance"
  type        = string
}

variable "vpc_id" {
  description = "Main VPC ID"
  type        = string
}

variable "public_key" {
  description = "Public Key for SSH Tunnel to EC2 Instance"
  type        = string
}

variable "allowed_ip_addresses" {
  description = "IP addresses that are allowed to SSH tunnel to the EC2 Instance"
  type        = list(string)
}
