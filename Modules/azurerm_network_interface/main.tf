resource "azurerm_network_interface" "nics" {
  for_each            = var.nics
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = var.tags

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration
    content {
      name                          = ip_configuration.value.ip_name
      subnet_id                     = data.azurerm_subnet.network_subnet_id[each.key].id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = try(data.azurerm_public_ip.network_pip_data[ip_configuration.value.public_ip_address_id].id, null)
    }
  }
}
