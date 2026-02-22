resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = var.tags
  
  # -------- address_space OR ip_address_pool --------
  address_space = each.value.ip_address_pool == null ? each.value.address_space : null

  dns_servers  = each.value.dns_servers
  bgp_community = each.value.bgp_community
  edge_zone     = each.value.edge_zone

  flow_timeout_in_minutes        = each.value.flow_timeout_in_minutes
  private_endpoint_vnet_policies = each.value.private_endpoint_vnet_policies

  # -------- DDOS --------
  dynamic "ddos_protection_plan" {
    for_each = each.value.ddos_protection_plan == null ? [] : [each.value.ddos_protection_plan]
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  # -------- Encryption --------
  dynamic "encryption" {
    for_each = each.value.encryption == null ? [] : [each.value.encryption]
    content {
      enforcement = encryption.value.enforcement
    }
  }

  # -------- IP Address Pool --------
  dynamic "ip_address_pool" {
    for_each = each.value.ip_address_pool == null ? [] : each.value.ip_address_pool
    content {
      id                     = ip_address_pool.value.id
      number_of_ip_addresses = ip_address_pool.value.number_of_ip_addresses
    }
  }

  # -------- Subnets --------
  dynamic "subnet" {
  for_each = each.value.subnets

  content {
    name             = subnet.value.name
    address_prefixes = subnet.value.address_prefixes

    security_group =lookup(subnet.value, "security_group", null)

    route_table_id =lookup(subnet.value, "route_table_id", null)

    service_endpoints =lookup(subnet.value, "service_endpoints", null)

    service_endpoint_policy_ids =lookup(subnet.value, "service_endpoint_policy_ids", null)

    default_outbound_access_enabled =lookup(subnet.value, "default_outbound_access_enabled", null)

    private_endpoint_network_policies =lookup(subnet.value, "private_endpoint_network_policies", null)

    private_link_service_network_policies_enabled =lookup(subnet.value,"private_link_service_network_policies_enabled",null)

    # ---- Delegation ----
    dynamic "delegation" {
      for_each = lookup(subnet.value, "delegations", [])

      content {
        name = delegation.value.name

        service_delegation {
          name    = delegation.value.service_name
          actions = lookup(delegation.value, "actions", null)
        }
      }
    }
  }
}
}

  