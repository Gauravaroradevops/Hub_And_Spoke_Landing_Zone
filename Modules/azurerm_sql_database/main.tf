resource "azurerm_mssql_database" "mssqldb" {
  for_each     = var.sqldb
  name         = each.value.name
  server_id    = data.azurerm_mssql_server.sql_server_data[each.key].id
  collation    = each.value.collation
  license_type = each.value.license_type
  max_size_gb  = each.value.max_size_gb
  sku_name     = each.value.sku_name
  enclave_type = each.value.enclave_type
  tags         = var.tags
}