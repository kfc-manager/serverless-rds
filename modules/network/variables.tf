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

variable "vpc_cidr" {
  description = "CIDR block of the whole VPC"
  type        = string
}

variable "public_cidrs" {
  description = "List of CIDR blocks of public subnets"
  type        = list(string)
}

variable "private_cidrs" {
  description = "List of CIDR blocks of private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones where the subnets live in"
  type        = list(string)
}
