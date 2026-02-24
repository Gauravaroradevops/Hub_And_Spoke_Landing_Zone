resource "azurerm_firewall" "firewall" {
  for_each            = var.firewall
  name                = each.value.firewall_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  tags                = var.tags

  ip_configuration {
    name                 = each.value.firewall_ip_name
    subnet_id            = data.azurerm_subnet.firewall_subnet_data[each.key].id
    public_ip_address_id = data.azurerm_public_ip.firewall_pip[each.key].id
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rules" {
  for_each            = var.firewall
  name                = "nat-rule-collection"
  azure_firewall_name = azurerm_firewall.firewall[each.key].name
  resource_group_name = each.value.resource_group_name
  priority            = 100
  action              = "Dnat"

  dynamic "rule" {
    for_each = each.value.nat_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = [data.azurerm_public_ip.firewall_pip[each.key].ip_address]
      destination_ports     = rule.value.destination_ports
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
      protocols             = rule.value.protocols
    }
  }
}
resource "azurerm_firewall_network_rule_collection" "network_rules" {
  for_each            = var.firewall
  name                = "network-rule-collection"
  azure_firewall_name = azurerm_firewall.firewall[each.key].name
  resource_group_name = each.value.resource_group_name
  priority            = 101
  action              = "Allow"

  dynamic "rule" {
    for_each = each.value.network_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }
}