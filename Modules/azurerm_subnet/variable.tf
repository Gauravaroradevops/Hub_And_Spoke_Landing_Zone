variable "subnets" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    nsg_name             = optional(string)
    # one of these required
    address_prefixes = optional(list(string))

    ip_address_pool = optional(object({
      id                     = string
      number_of_ip_addresses = string
    }))

    default_outbound_access_enabled               = optional(bool)
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool)

    service_endpoints           = optional(list(string))
    service_endpoint_policy_ids = optional(list(string))
    sharing_scope               = optional(string)

    delegation = optional(list(object({
      name         = string
      service_name = string
      actions      = optional(list(string))
    })))

    # timeouts
    create_timeout = optional(string)
    read_timeout   = optional(string)
    update_timeout = optional(string)
    delete_timeout = optional(string)
  }))
}

variable "tags" {
  type = map(string)
}
variable "nsg_ids" {
  type = map(string)
}