variable "pe_point" {
  type = map(object({
    name                            = string
    location                        = string
    private_dns_zone_group          = string
    resource_group_name             = string
    subnet_name                     = string
    virtual_network_name            = string
    private_service_connection_name = string
    sql_server_name                 = string
    vnet_name                       = string
    vnet_resource_group_name        = string
    subresource_names               = list(string)
    is_manual_connection            = bool
    db_dns_name                     = string
    sqldb_dns_vnet_link             = string
  }))
}

