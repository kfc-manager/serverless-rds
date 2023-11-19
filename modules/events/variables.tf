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

variable "ssh_metric_alarm_arn" {
  description = "ARN of SSH traffic metric alarm"
  type        = string
}

variable "start_lambda_arn" {
  description = "ARN of start RDS Lambda function"
  type        = string
}

variable "stop_lambda_arn" {
  description = "ARN of stop RDS Lambda function"
  type        = string
}
