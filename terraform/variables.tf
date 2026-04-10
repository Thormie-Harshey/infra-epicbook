variable "location" {
  default = "West Europe"
}

variable "resource_group_name" {
  default = "epicbooks-rg"
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key_path" {}

variable "db_password" {
  sensitive = true
}