resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name

  # Exactly one of address_prefixes or ip_address_pool
  address_prefixes = lookup(each.value, "address_prefixes", null)

  default_outbound_access_enabled               = lookup(each.value, "default_outbound_access_enabled", true)
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_network_policies", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", true)
  service_endpoints                             = lookup(each.value, "service_endpoints", null)
  service_endpoint_policy_ids                   = lookup(each.value, "service_endpoint_policy_ids", null)
  sharing_scope                                 = lookup(each.value, "sharing_scope", null)

  # ---------------- DELEGATION ----------------
  dynamic "delegation" {
    for_each = each.value.delegation == null ? [] : each.value.delegation
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_name
        actions = lookup(delegation.value, "actions", null)
      }
    }
  }

  # ---------------- IP ADDRESS POOL ----------------
  dynamic "ip_address_pool" {
    for_each = each.value.ip_address_pool == null ? [] : [each.value.ip_address_pool]
    content {
      id                     = ip_address_pool.value.id
      number_of_ip_addresses = ip_address_pool.value.number_of_ip_addresses
    }
  }

  timeouts {
    create = lookup(each.value, "create_timeout", "30m")
    read   = lookup(each.value, "read_timeout", "5m")
    update = lookup(each.value, "update_timeout", "30m")
    delete = lookup(each.value, "delete_timeout", "30m")
  }
}

resource "azurerm_subnet_network_security_group_association" "associan" {
    for_each = {
    for k, v in var.subnets :
    k => v
    if try(v.nsg_name, null) != null
  }
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = var.nsg_ids[each.value.nsg_name]
}
