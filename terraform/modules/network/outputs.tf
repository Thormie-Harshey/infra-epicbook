output "public_subnet_id" {
  value = azurerm_subnet.public.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private.id
}

output "vnet_id" {
  value = azurerm_virtual_network.your_vnet_name.id
}