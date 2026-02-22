data "azurerm_key_vault" "vm_key_vault_id" {
  for_each            = var.vms
  name                = each.value.key_vault_name
  resource_group_name = each.value.resource_group_name
}
data "azurerm_key_vault_secret" "vm_kvsdvm" {
  for_each     = var.vms
  name         = each.value.secretu_name
  key_vault_id = data.azurerm_key_vault.vm_key_vault_id[each.key].id
}
data "azurerm_key_vault_secret" "vm_kvsdtvm" {
  for_each     = var.vms
  name         = each.value.secretp_name
  key_vault_id = data.azurerm_key_vault.vm_key_vault_id[each.key].id
}
data "azurerm_network_interface" "vm_nic_d" {
  for_each            = var.vms
  name                = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_monitor_data_collection_rule" "vm_dcrd" {
  for_each = var.vms
  name                = "data_collection_rule"
  resource_group_name = "dev-todo-rg"
}