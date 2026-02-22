data "azurerm_subnet" "firewall_subnet_data" {
  for_each             = var.firewall
  name                 = each.value.firewall_subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "firewall_pip" {
  for_each            = var.firewall
  name                = each.value.firewall_pip_name
  resource_group_name = each.value.resource_group_name
}