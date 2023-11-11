output "db_security_group_id" {
  description = "ID of the Security Group which is allowed to access the Database"
  value       = aws_security_group.to_database.id
}

output "id" {
  description = "Identifier of the RDS Instance"
  value       = aws_db_instance.main.id
}

output "arn" {
  description = "ARN of the RDS Instance"
  value       = aws_db_instance.main.arn
}
