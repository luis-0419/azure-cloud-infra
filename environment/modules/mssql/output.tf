output "id" {
  value = azurerm_mssql_server.mssql_server.id
}

output "name" {
  value = azurerm_mssql_server.mssql_server.name
}

output "db_ids" {
  value = { for database in azurerm_mssql_database.database : database.name => database.id }
}