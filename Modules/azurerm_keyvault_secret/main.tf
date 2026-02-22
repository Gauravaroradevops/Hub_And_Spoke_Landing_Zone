resource "azurerm_key_vault_secret" "kvs" {
  for_each     = var.kvs
  name         = each.value.secret-name
  value        = each.value.secret_type
  key_vault_id = data.azurerm_key_vault.key_vault_id[each.key].id
  
}
