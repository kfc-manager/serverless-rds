output "public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.bastion_host.public_ip
}

output "db_host_endpoint" {
  description = "Host endpoint of RDS instance"
  value       = module.database.endpoint
}
