output "vm_public_ip" {
  value = module.compute.vm_public_ip
}

output "mysql_fqdn" {
  value = module.database.mysql_fqdn
}