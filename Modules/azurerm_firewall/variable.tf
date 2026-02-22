variable "firewall" {
  type = map(object({
    firewall_name        = string
    location             = string
    resource_group_name  = string
    sku_name             = string
    sku_tier             = string
    firewall_ip_name     = string
    firewall_subnet_name = string
    virtual_network_name = string
    firewall_pip_name    = string

    nat_rules = list(object({
      name                  = string
      source_addresses      = list(string)
      destination_ports     = list(string)
      translated_port       = number
      translated_address    = string
      protocols             = list(string)
    }))

    network_rules = list(object({
      name                  = string
      source_addresses      = list(string)
      destination_ports     = list(string)
      destination_addresses = list(string)
      protocols             = list(string)
    }))
  }))
}

variable "tags" {
  type = map(string)
}


