data "azurerm_virtual_network" "peering_vnet_data" {
  for_each            = var.peering
  name                = each.value.remote_vnet_name
  resource_group_name = each.value.resource_group_name
}
