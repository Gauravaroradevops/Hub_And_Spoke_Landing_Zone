resource "azurerm_application_gateway" "appgateway" {
  for_each            = var.appgateway
  name                = each.value.appgateway_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  tags                = var.tags
  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.sku_capacity
  }

  gateway_ip_configuration {
    name      = each.value.gateway_ip_name
    subnet_id = data.azurerm_subnet.agw_subnet_id[each.key].id

  }

  frontend_port {
    name = each.value.frontend_port_name
    port = each.value.frontend_port_number
  }

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.agw_pip[each.key].id
  }

  frontend_ip_configuration {
    name                          = each.value.private_frontend_ip_configuration_name
    subnet_id                     = data.azurerm_subnet.agw_subnet_id[each.key].id
    private_ip_address_allocation = each.value.private_ip_address_allocation
    private_ip_address            = each.value.private_ip_address
  }

  dynamic "backend_address_pool" {
    for_each = each.value.backend_address_pool
    content {
      name         = backend_address_pool.value.backend_address_pool_name
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = each.value.backend_http_settings
    content {
      name                  = backend_http_settings.value.http_setting_name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      path                  = backend_http_settings.value.path
      port                  = backend_http_settings.value.backend_pool_port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "http_listener" {
    for_each = each.value.http_listener
    content {
      name                           = http_listener.value.listener_name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.listner_protocol
      host_name                      = http_listener.value.host_name
    }

  }

  dynamic "request_routing_rule" {
    for_each = each.value.request_routing_rule
    content {
      name                       = request_routing_rule.value.request_routing_rule_name
      priority                   = request_routing_rule.value.priority
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }

  }
}
