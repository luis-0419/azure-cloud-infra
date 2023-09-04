resource "azurerm_storage_account" "storage_account" {
  name                = var.name
  resource_group_name = var.resource_group_name

  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [var.subnet_id]
  }

  tags = {
    environment = var.environment
  }
}