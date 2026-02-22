variable "appgateway" {
  type = map(object({
    appgateway_name                        = string
    resource_group_name                    = string
    location                               = string
    sku_name                               = string
    sku_tier                               = string
    sku_capacity                           = string
    gateway_ip_name                        = string
    subnet_name                            = string
    virtual_network_name                   = string
    frontend_port_number                   = number
    agw_pip_name                           = string
    private_ip_address                     = string
    private_ip_address_allocation          = string
    frontend_ip_configuration_name         = string
    private_frontend_ip_configuration_name = string


    frontend_port_name = string
    backend_address_pool = list(object({
      ip_addresses              = list(string)
      backend_address_pool_name = string
    }))
    backend_http_settings = list(object({
      http_setting_name     = string
      cookie_based_affinity = string
      path                  = string
      backend_pool_port     = number
      protocol              = string
      request_timeout       = number
    }))
    http_listener = list(object({
      listner_protocol               = string
      listener_name                  = string
      host_name                      = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
    }))
    request_routing_rule = list(object({
      priority                   = number
      rule_type                  = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
      request_routing_rule_name  = string
      listener_name              = string
    }))
  }))
}

variable "tags" {
  type = map(string)
}
