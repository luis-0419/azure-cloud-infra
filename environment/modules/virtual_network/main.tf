resource "azurerm_virtual_network" "virtual_network" {

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  depends_on = [ 
    var.resource_group_name
   ]
  tags = {
    Environment = var.environment_name
  }
}

resource "azurerm_subnet" "subnet" {
  
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                = each.name
  resource_group_name = var.resource_group_name
  address_prefix      = each.value.address_prefix
}