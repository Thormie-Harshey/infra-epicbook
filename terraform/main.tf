module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "compute" {
  source              = "./modules/compute"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network.public_subnet_id
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
}

module "database" {
  source              = "./modules/database"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = module.network.private_subnet_id
  db_password         = var.db_password
}