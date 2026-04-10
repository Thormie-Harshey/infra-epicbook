variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "db_password" {
  sensitive = true
}
variable "vnet_id" {}