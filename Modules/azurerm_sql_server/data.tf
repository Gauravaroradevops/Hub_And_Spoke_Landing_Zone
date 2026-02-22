data "azurerm_key_vault" "sql_key_vault_id" {
  for_each            = nonsensitive(var.sql_s)
  name                = each.value.key_vault_name
  resource_group_name = each.value.resource_group_name
}
data "azurerm_key_vault_secret" "sql_kvsd" {
  for_each     = nonsensitive(var.sql_s)
  name         = each.value.secret_name
  key_vault_id = data.azurerm_key_vault.sql_key_vault_id[each.key].id
}
data "azurerm_key_vault_secret" "sql_kvsdt" {
  for_each     = nonsensitive(var.sql_s)
  name         = each.value.secret_type
  key_vault_id = data.azurerm_key_vault.sql_key_vault_id[each.key].id
}
