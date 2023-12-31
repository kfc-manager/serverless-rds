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

variable "region" {
  description = "AWS region of infrastructure"
  type        = string
}

variable "account_id" {
  description = "Account ID of user who builds this infrastructure"
  type        = string
}

variable "function_name" {
  description = "Name of Lambda function"
  type        = string
}

variable "ecr_image_tag" {
  description = "Tag of image in ECR repository which Lambda function executes"
  type        = string
}

variable "description" {
  description = "Description what Lambda function does"
  type        = string
}

variable "role_arn" {
  description = "ARN of IAM role assigned to Lambda function"
  type        = string
}

variable "env_variables" {
  description = "Environment variables set in Lambda function"
  type        = map(string)
}
