# 1. Create a Private DNS Zone for the MySQL Server
resource "azurerm_private_dns_zone" "mysql_dns" {
  name                = "bookstore.private.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

# 2. Link the DNS Zone to your VNet so the VM can resolve the name
resource "azurerm_private_dns_zone_virtual_network_link" "mysql_vnet_link" {
  name                  = "mysql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.mysql_dns.name
  virtual_network_id    = var.vnet_id
}

# 3. Update the MySQL Server to use the Private DNS Zone
resource "azurerm_mysql_flexible_server" "db" {
  name                   = "bookstore"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = "adminuser"
  administrator_password = var.db_password
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"

  delegated_subnet_id    = var.subnet_id
  
  # This tells the DB to register its FQDN in your new DNS Zone
  private_dns_zone_id    = azurerm_private_dns_zone.mysql_dns.id

  # Ensure the link exists before trying to create the DB
  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql_vnet_link]

  lifecycle {
    ignore_changes = [
      zone,
    ]
  }
}