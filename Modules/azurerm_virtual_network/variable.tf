variable "vnets" {
  type = map(object({

    # -------- Required --------
    name                = string
    location            = string
    resource_group_name = string

    # exactly one required logically
    address_space = optional(list(string))
    ip_address_pool = optional(list(object({
      id                     = string
      number_of_ip_addresses = string
    })))

    # -------- Optional Scalars --------
    dns_servers   = optional(list(string), [])
    bgp_community = optional(string)
    edge_zone     = optional(string)

    flow_timeout_in_minutes        = optional(number)
    private_endpoint_vnet_policies = optional(string)

    # -------- Optional Blocks --------
    ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }))

    encryption = optional(object({
      enforcement = string
    }))

    # -------- Subnets --------
    subnets = optional(list(object({
      name             = string
      address_prefixes = list(string)
      security_group              = optional(string)
      route_table_id              = optional(string)
      service_endpoints           = optional(list(string))
      service_endpoint_policy_ids = optional(list(string))
      default_outbound_access_enabled = optional(bool)
      private_endpoint_network_policies = optional(string)
      private_link_service_network_policies_enabled = optional(bool)

      delegations = optional(list(object({
        name         = string
        service_name = string
        actions      = optional(list(string))
      })), [])

    })), [])

  }))
}

variable "tags" {
  type = map(string)
}
