output "public_ip" {
  description = "Public IP Address of the Bastion Host"
  value       = aws_eip.main.public_ip
}

output "network_interface_id" {
  description = "ID of the Network Interface of the Bastion Host"
  value       = aws_network_interface.main.id
}
