resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "compute" {
  source              = "./modules/compute"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.public_subnet_id
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
}

module "database" {
  source              = "./modules/database"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.private_subnet_id
  db_password         = var.db_password
}