data "azurerm_subnet" "pe_subnet_id" {
  for_each             = var.pe_point
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
data "azurerm_mssql_server" "pe_sql_server_data" {
  for_each            = var.pe_point
  name                = each.value.sql_server_name
  resource_group_name = each.value.resource_group_name
}
data "azurerm_virtual_network" "pe_virtual_net_data" {
  for_each            = var.pe_point
  name                = each.value.vnet_name
  resource_group_name = each.value.vnet_resource_group_name
}
data "azurerm_resource_group" "pe_rg" {
  for_each = var.pe_point
  name     = each.value.resource_group_name
}