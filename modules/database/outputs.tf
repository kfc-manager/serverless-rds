output "security_group_id" {
  description = "ID of security group which is allowed to access RDS instance"
  value       = aws_security_group.outbound.id
}

output "id" {
  description = "ID of RDS instance"
  value       = aws_db_instance.main.id
}

output "arn" {
  description = "ARN of RDS instance"
  value       = aws_db_instance.main.arn
}

output "endpoint" {
  description = "Host endpoint of RDS instance"
  value       = aws_db_instance.main.endpoint
}
