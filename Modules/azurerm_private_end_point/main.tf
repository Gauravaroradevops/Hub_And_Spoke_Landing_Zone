resource "azurerm_private_endpoint" "pe_point" {
  for_each            = var.pe_point
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = data.azurerm_subnet.pe_subnet_id[each.key].id

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = data.azurerm_mssql_server.pe_sql_server_data[each.key].id #sql_server_id
    subresource_names              = each.value.subresource_names
    is_manual_connection           = each.value.is_manual_connection
  }

  private_dns_zone_group {
    name                 = each.value.private_dns_zone_group
    private_dns_zone_ids = [azurerm_private_dns_zone.p_zone[each.key].id]
  }
}

resource "azurerm_private_dns_zone" "p_zone" {
  for_each            = var.pe_point
  name                = each.value.db_dns_name
  resource_group_name = data.azurerm_resource_group.pe_rg[each.key].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "zone_to_vnet_link" {
  for_each              = var.pe_point
  name                  = each.value.sqldb_dns_vnet_link
  resource_group_name   = data.azurerm_resource_group.pe_rg[each.key].name
  private_dns_zone_name = azurerm_private_dns_zone.p_zone[each.key].name
  virtual_network_id    = data.azurerm_virtual_network.pe_virtual_net_data[each.key].id
}



