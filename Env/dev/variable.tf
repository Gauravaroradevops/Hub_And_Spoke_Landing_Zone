variable "rgs" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
  }))
}

variable "stgs" {
  type = map(object({
    name                     = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    resource_group_name      = string
    account_kind             = optional(string)
    access_tier              = optional(string)
    edge_zone                = optional(string)

    https_traffic_only_enabled        = optional(bool)
    min_tls_version                   = optional(string)
    allow_nested_items_to_be_public   = optional(bool)
    shared_access_key_enabled         = optional(bool)
    public_network_access_enabled     = optional(bool)
    cross_tenant_replication_enabled  = optional(bool)
    infrastructure_encryption_enabled = optional(bool)

    is_hns_enabled           = optional(bool)
    nfsv3_enabled            = optional(bool)
    sftp_enabled             = optional(bool)
    large_file_share_enabled = optional(bool)
    local_user_enabled       = optional(bool)

    dns_endpoint_type = optional(string)

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(list(string))
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))

    static_website = optional(object({
      index_document     = optional(string)
      error_404_document = optional(string)
    }))

    routing = optional(object({
      choice                      = optional(string)
      publish_internet_endpoints  = optional(bool)
      publish_microsoft_endpoints = optional(bool)
    }))

    blob_properties = optional(object({
      versioning_enabled       = optional(bool)
      change_feed_enabled      = optional(bool)
      last_access_time_enabled = optional(bool)

      delete_retention_policy = optional(object({
        days = number
      }))

      container_delete_retention_policy = optional(object({
        days = number
      }))
    }))

    share_properties = optional(object({
      retention_policy = optional(object({
        days = number
      }))
    }))

    queue_properties = optional(object({
      logging = optional(object({
        read    = bool
        write   = bool
        delete  = bool
        version = string
      }))
    }))

    tags = optional(map(string))
  }))
}

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
      name                                          = string
      address_prefixes                              = list(string)
      security_group                                = optional(string)
      route_table_id                                = optional(string)
      service_endpoints                             = optional(list(string))
      service_endpoint_policy_ids                   = optional(list(string))
      default_outbound_access_enabled               = optional(bool)
      private_endpoint_network_policies             = optional(string)
      private_link_service_network_policies_enabled = optional(bool)

      delegations = optional(list(object({
        name         = string
        service_name = string
        actions      = optional(list(string))
      })), [])

    })), [])

  }))
}

variable "keyvault" {
  type = map(object({

    # -------- Required --------
    name                = string
    location            = string
    resource_group_name = string
    sku_name            = string

    # -------- Core Security --------
    tenant_id = optional(string)

    soft_delete_retention_days = optional(number, 90)
    purge_protection_enabled   = optional(bool, true)

    rbac_authorization_enabled    = optional(bool, true)
    public_network_access_enabled = optional(bool, true)

    enabled_for_deployment          = optional(bool, false)
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)

    # -------- Network ACLs --------
    network_acls = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))

    # -------- Access Policies --------
    access_policies = optional(list(object({
      tenant_id = string
      object_id = string

      application_id = optional(string)

      key_permissions         = optional(list(string))
      secret_permissions      = optional(list(string))
      certificate_permissions = optional(list(string))
      storage_permissions     = optional(list(string))
    })), [])

  }))
}
variable "kvs" {
  type = map(object({
    secret-name         = string
    resource_group_name = string
    key_vault_name      = string
    secret_type         = string
  }))
}

variable "pips" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = string
  }))
}

variable "nsgs" {
  type = map(object({
    nsg_name            = string
    location            = string
    resource_group_name = string
    dynamic = optional(map(object({
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

variable "nics" {
  type = map(object({
    nic_name             = string
    location             = string
    resource_group_name  = string
    subnet_name          = string
    virtual_network_name = string
    pip_name             = optional(string, null)
    ip_configuration = list(object({
      ip_name                       = string
      private_ip_address_allocation = string
      public_ip_address_id          = optional(string)
      private_ip_address            = string
    }))

    }
  ))
}

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
variable "sql_s" {
  sensitive = true
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    version             = string
    minimum_tls_version = string
    key_vault_name      = string
    secret_name         = string
    secret_type         = string
  }))
}

variable "sqldb" {
  type = map(object({
    sql_server_name     = string
    resource_group_name = string
    name                = string
    collation           = optional(string)
    license_type        = optional(string)
    max_size_gb         = optional(string)
    sku_name            = optional(string)
    enclave_type        = optional(string)
  }))
}

variable "pe_point" {
  type = map(object({
    name                            = string
    private_dns_zone_group          = string
    location                        = string
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

variable "vms" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    size                 = string
    caching              = string
    storage_account_type = string
    publisher            = string
    offer                = string
    sku                  = string
    version              = string
    key_vault_name       = string
    secretu_name         = string
    secretp_name         = string
    nic_name             = string
    lun                  = string
    disk_name            = string
    create_option        = string
    disk_size_gb         = string
    custom_data          = string
  }))
}

variable "lbs" {
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    fip_conf_name                 = string
    lb_b_pool                     = string
    lb_rule_name                  = string
    protocol                      = string
    frontend_port                 = number
    backend_port                  = number
    lb_probe_name                 = string
    lb_probe_port                 = number
    be_vm_nic_names               = list(string)
    lb_private_ip                 = string
    subnet_name                   = string
    virtual_network_name          = string
    private_ip_address_allocation = string
    be_vm_nic_ip_conf_name        = string
  }))
}


variable "hub_bastion" {
  type = map(object({
    name                  = string
    location              = string
    resource_group_name   = string
    ip_configuration_name = string
    public_ip             = string
    subnet_name           = string
    virtual_network_name  = string
  }))
}

variable "peering" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    remote_vnet_name     = string
  }))

}



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

variable "log_analytics_workspace" {
  type = map(object({
    workspace_name      = string
    location            = string
    resource_group_name = string
    sku                 = string
    retention_in_days   = string
    dcr_name            = string
    destination_name    = string
  }))

}

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