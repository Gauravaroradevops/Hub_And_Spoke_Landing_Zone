data "azurerm_key_vault" "key_vault_id" {
  for_each = var.kvs
  name                = each.value.key_vault_name
  resource_group_name = each.value.resource_group_name
}