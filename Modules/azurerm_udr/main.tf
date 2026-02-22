resource "azurerm_route_table" "route_table" {
  for_each            = var.route_table
  name                = each.value.route_table_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dynamic "route" {
    for_each = each.value.route
    content {
      name                   = route.value.route_name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = data.azurerm_firewall.firewall_data[each.key].ip_configuration[0].private_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "S_RT_A" {
  for_each       = var.route_table
  subnet_id      = data.azurerm_subnet.rt_subnet_data[each.key].id
  route_table_id = azurerm_route_table.route_table[each.key].id
}




