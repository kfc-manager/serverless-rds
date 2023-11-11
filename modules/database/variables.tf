variable "identifier" {
  description = "Identifier of the RDS Instance"
  type        = string
}

variable "vpc_id" {
  description = "ID of the Main VPC"
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

variable "allocated_storage" {
  description = "Storage size of the Database"
  type        = number
}

variable "instance_class" {
  description = "Instance class of the RDS Instance"
  type        = string
}

variable "db_name" {
  description = "Name of the Database"
  type        = string
}

variable "db_username" {
  description = "Username of the master user in the Database"
  type        = string
}

variable "db_password" {
  description = "Password of the master user in the Database"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Subnet Group name in which the RDS Instance operates in"
  type        = string
}

variable "db_port" {
  description = "Port on which the database of the RDS Instance listens on"
  type        = number
}

variable "db_engine" {
  description = "Engine on which the database of the RDS Instance runs on"
  type        = string
}

variable "db_engine_version" {
  description = "Version of the engine on which the database of the RDS Instance runs on"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Flag for creating a final snapshot before database deletion"
  type        = bool
}
