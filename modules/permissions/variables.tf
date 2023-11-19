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

variable "rds_arn" {
  description = "ARN of RDS instance to be stopped and started"
  type        = string
}

variable "metric_alarm_arn" {
  description = "ARN of metric alarm for RDS traffic"
  type        = string
}
