resource "azurerm_mssql_server" "sql_s" {
  for_each                     = nonsensitive(var.sql_s)
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = each.value.version
  administrator_login          = data.azurerm_key_vault_secret.sql_kvsd[each.key].value
  administrator_login_password = data.azurerm_key_vault_secret.sql_kvsdt[each.key].value
  minimum_tls_version          = each.value.minimum_tls_version
  tags                         = var.tags

}


