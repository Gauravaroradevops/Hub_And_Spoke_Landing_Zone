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

    rbac_authorization_enabled = optional(bool, true)
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

variable "tags" {
  type = map(string)
}
