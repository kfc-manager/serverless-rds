output "stop_role_arn" {
  description = "ARN of IAM role for stop Lambda function"
  value       = aws_iam_role.stop.arn
}

output "start_role_arn" {
  description = "ARN of IAM role for start Lambda function"
  value       = aws_iam_role.start.arn
}
