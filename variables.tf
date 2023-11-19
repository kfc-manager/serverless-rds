variable "db_name" {
  description = "Name of database (remember as needed for database access)"
  type        = string
}

variable "db_username" {
  description = "Username of master user in database (remember as needed for database access)"
  type        = string
}

variable "db_password" {
  description = "Password of master user in database (remember as needed for database access)"
  type        = string
}

variable "allowed_ip_addresses" {
  description = "List of allowed IP address ranges e.g. [\"{your IP address}/32\"] to whitlist your IP address"
  type        = list(string)
}
