variable "region" {
  description = "Region of the Main VPC, ECR Repository and Lambda Function"
  type        = string
}

variable "stop" {
  description = "Whether this is a Function that stops or starts the RDS Instance"
  type        = bool
}

variable "rds_identifier" {
  description = "Identifier of the RDS Instance to shut down"
  type        = string
}

variable "ecr_image_tag" {
  description = "Tag of image that the Lambda Function executes"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda Function"
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

variable "db_arn" {
  description = "ARN of the RDS Instance to shut down"
  type        = string
}
