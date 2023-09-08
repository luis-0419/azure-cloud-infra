output "id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "subnet_ids" {
  value = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}