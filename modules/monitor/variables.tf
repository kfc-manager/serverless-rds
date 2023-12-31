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

variable "network_interface_id" {
  description = "ID of network interface which traffic needs to be monitored"
  type        = string
}

variable "db_port" {
  description = "Port on which database of RDS instance listens on"
  type        = number
}

