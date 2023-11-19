variable "project_tag" {
  description = "Project tag functioning as identifier for resources"
  type        = string
}

variable "project" {
  description = "Full project name"
  type        = string
}

variable "env" {
  description = "Environment e.g. production or development"
  type        = string
}

variable "vpc_id" {
  description = "ID of main VPC"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID of EC2 instance (bastion host)"
  type        = string
}

variable "db_security_group_id" {
  description = "ID of security group to access database"
  type        = string
}

variable "instance_type" {
  description = "Instance class of EC2 instance (bastion host)"
  type        = string
}

variable "public_ssh_key" {
  description = "Public key for SSH tunnel to EC2 instance (bastion host)"
  type        = string
}

variable "allowed_ip_addresses" {
  description = "List of IP addresses that are allowed to SSH tunnel to EC2 instance (bastion host)"
  type        = list(string)
}
