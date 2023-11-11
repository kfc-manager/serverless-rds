output "id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the Public Subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnet_group_name" {
  description = "Name of Private Subnet Group"
  value       = aws_db_subnet_group.private.name
}
