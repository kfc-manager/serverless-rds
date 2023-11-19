output "public_ip" {
  description = "Public IP address of bastion host"
  value       = aws_eip.main.public_ip
}

output "network_interface_id" {
  description = "ID of network interface of EC2 instance (bastion host)"
  value       = aws_network_interface.main.id
}
