variable "tags" {
  type = map(string)
}
variable "nsgs" {
  type = map(object({
    nsg_name            = string
    location            = string
    resource_group_name = string
    security_rule = optional(map(object({
      rule_name                  = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), {})
  }))
}
