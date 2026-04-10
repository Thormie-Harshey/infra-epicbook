resource "azurerm_mysql_flexible_server" "db" {
  name                   = "bookstore"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = "adminuser"
  administrator_password = var.db_password
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"

  delegated_subnet_id = var.subnet_id

  lifecycle {
    ignore_changes = [
      zone,
    ]
  }
}