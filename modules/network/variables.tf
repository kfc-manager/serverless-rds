variable "vpc_cidr_block" {
  description = "CIDR Block of the whole VPC"
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

variable "public_subnet_cidrs" {
  description = "CIDR Blocks of the Public Subnet"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR Blocks of the Private Subnet"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability Zones of the Subnets"
  type        = list(string)
}
