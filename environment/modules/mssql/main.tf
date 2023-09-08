resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.version
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_mssql_database" "database" {

  for_each = { for database in var.databases : database.name => database }

  name           = each.value.name
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = each.value.collation
  license_type   = each.value.license_type
  max_size_gb    = each.value.max_size_gb
  read_scale     = true
  sku_name       = each.value.sku_name
  zone_redundant = true

  tags = {
    Environment = var.environment_name
  }
}