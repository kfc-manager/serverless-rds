output "id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnet_group_name" {
  description = "Name of private subnet group"
  value       = aws_db_subnet_group.private.name
}

