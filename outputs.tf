output "public_ip" {
  description = "Public IP Address of the Bastion Host"
  value       = module.bastion_host.public_ip
}
