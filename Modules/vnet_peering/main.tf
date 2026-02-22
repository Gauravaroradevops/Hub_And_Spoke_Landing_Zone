resource "azurerm_virtual_network_peering" "A-B_B-A" {
  for_each                  = var.peering
  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = data.azurerm_virtual_network.peering_vnet_data[each.key].id
  allow_forwarded_traffic   = true

}

