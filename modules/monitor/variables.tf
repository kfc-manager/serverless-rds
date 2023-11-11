variable "bastion_host_network_interface_id" {
  description = "ID of the Network Interface of the Bastion Host to monitor"
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

variable "port" {
  description = "Port on which the Database of the RDS Instance listens on"
  type        = number
}

variable "trigger_period" {
  description = "Period in minutes after which the RDS instance should be shut down if there was no traffic"
  type        = number
}

variable "lambda_arn" {
  description = "ARN of the Lambda that gets invoked by the CloudWatch alarm"
  type        = string
}
