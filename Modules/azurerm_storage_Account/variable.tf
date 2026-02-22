variable "stgs" {
  type = map(object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
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


variable "tags" {
  type = map(string)
  
}
