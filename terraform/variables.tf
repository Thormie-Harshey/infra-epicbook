variable "location" {
  default = "Norwway East"
}

variable "resource_group_name" {
  default = "epicbook-rg"
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key_path" {}

variable "db_password" {
  sensitive = true
}