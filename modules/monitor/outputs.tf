output "rds_metric_alarm_arn" {
  description = "ARN of metric alarm for RDS traffic"
  value       = aws_cloudwatch_metric_alarm.database.arn
}

output "rds_metric_alarm_name" {
  description = "Name of metric alarm for RDS traffic"
  value       = local.rds_metric_alarm_name
}

output "ssh_metric_alarm_arn" {
  description = "ARN of metric alarm for SSH traffic"
  value       = aws_cloudwatch_metric_alarm.ssh.arn
}
