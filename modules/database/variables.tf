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

variable "allocated_storage" {
  description = "Storage size of the database"
  type        = string
}

variable "instance_class" {
  description = "Instance class of RDS instance"
  type        = string
}

variable "db_name" {
  description = "Name of database"
  type        = string
}

variable "db_username" {
  description = "Username of master user in database"
  type        = string
}

variable "db_password" {
  description = "Password of master user in database"
  type        = string
}

variable "subnet_group_name" {
  description = "Name of subnet group in which RDS instance lives in"
  type        = string
}

variable "db_port" {
  description = "Port on which RDS instance listens on"
  type        = number
}

variable "db_engine" {
  description = "Engine on which database of RDS instance runs on"
  type        = string
}

variable "db_engine_version" {
  description = "Version of engine on which database of RDS instance runs on"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Flag for wether or not creating a final snapshot before database deletion"
  type        = bool
}
