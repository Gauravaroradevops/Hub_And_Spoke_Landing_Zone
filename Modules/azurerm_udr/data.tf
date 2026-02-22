data "azurerm_firewall" "firewall_data" {
  for_each            = var.route_table
  name                = each.value.firewall_name
  resource_group_name = each.value.resource_group_name
}
data "azurerm_subnet" "rt_subnet_data" {
  for_each             = var.route_table
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
