data "azurerm_mssql_server" "sql_server_data" {
  for_each            = var.sqldb
  name                = each.value.sql_server_name
  resource_group_name = each.value.resource_group_name
}
