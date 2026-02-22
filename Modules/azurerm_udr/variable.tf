variable "route_table" {
  type = map(object({
    route_table_name     = string
    location             = string
    resource_group_name  = string
    firewall_name        = string
    subnet_name          = string
    virtual_network_name = string
    route = list(object({
      route_name     = string
      address_prefix = string
      next_hop_type  = string
    }))
  }))
}