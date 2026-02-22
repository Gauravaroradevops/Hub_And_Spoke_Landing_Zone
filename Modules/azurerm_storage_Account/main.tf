resource "azurerm_storage_account" "stg" {
  for_each = var.stgs

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

  account_kind = lookup(each.value, "account_kind", "StorageV2")
  access_tier  = lookup(each.value, "access_tier", null)
  edge_zone    = lookup(each.value, "edge_zone", null)

  https_traffic_only_enabled        = lookup(each.value, "https_traffic_only_enabled", true)
  min_tls_version                   = lookup(each.value, "min_tls_version", "TLS1_2")
  allow_nested_items_to_be_public   = lookup(each.value, "allow_nested_items_to_be_public", false)
  shared_access_key_enabled         = lookup(each.value, "shared_access_key_enabled", true)
  public_network_access_enabled     = lookup(each.value, "public_network_access_enabled", true)
  cross_tenant_replication_enabled  = lookup(each.value, "cross_tenant_replication_enabled", false)
  infrastructure_encryption_enabled = lookup(each.value, "infrastructure_encryption_enabled", false)

  is_hns_enabled           = lookup(each.value, "is_hns_enabled", null)
  nfsv3_enabled            = lookup(each.value, "nfsv3_enabled", null)
  sftp_enabled             = lookup(each.value, "sftp_enabled", null)
  large_file_share_enabled = lookup(each.value, "large_file_share_enabled", null)
  local_user_enabled       = lookup(each.value, "local_user_enabled", null)

  dns_endpoint_type = lookup(each.value, "dns_endpoint_type", null)

  tags = var.tags
  # ---------------- IDENTITY ----------------
  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  # ---------------- NETWORK RULES ----------------
  dynamic "network_rules" {
    for_each = each.value.network_rules == null ? [] : [each.value.network_rules]
    content {
      default_action             = network_rules.value.default_action
      bypass                     = lookup(network_rules.value, "bypass", null)
      ip_rules                   = lookup(network_rules.value, "ip_rules", null)
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", null)
    }
  }

  # ---------------- STATIC WEBSITE ----------------
  dynamic "static_website" {
    for_each = each.value.static_website == null ? [] : [each.value.static_website]
    content {
      index_document     = lookup(static_website.value, "index_document", null)
      error_404_document = lookup(static_website.value, "error_404_document", null)
    }
  }

  # ---------------- ROUTING ----------------
  dynamic "routing" {
    for_each = each.value.routing == null ? [] : [each.value.routing]
    content {
      choice                      = lookup(routing.value, "choice", null)
      publish_internet_endpoints  = lookup(routing.value, "publish_internet_endpoints", null)
      publish_microsoft_endpoints = lookup(routing.value, "publish_microsoft_endpoints", null)
    }
  }

  # ---------------- BLOB PROPERTIES ----------------
  dynamic "blob_properties" {
    for_each = each.value.blob_properties == null ? [] : [each.value.blob_properties]
    content {
      versioning_enabled       = lookup(blob_properties.value, "versioning_enabled", null)
      change_feed_enabled      = lookup(blob_properties.value, "change_feed_enabled", null)
      last_access_time_enabled = lookup(blob_properties.value, "last_access_time_enabled", null)

      dynamic "delete_retention_policy" {
        for_each = try(blob_properties.value.delete_retention_policy, null) == null ? [] : [blob_properties.value.delete_retention_policy]
        content {
          days = delete_retention_policy.value.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = try(blob_properties.value.container_delete_retention_policy, null) == null ? [] : [blob_properties.value.container_delete_retention_policy]
        content {
          days = container_delete_retention_policy.value.days
        }
      }
    }
  }

  # ---------------- SHARE PROPERTIES ----------------
  dynamic "share_properties" {
    for_each = each.value.share_properties == null ? [] : [each.value.share_properties]
    content {
      dynamic "retention_policy" {
        for_each = try(share_properties.value.retention_policy, null) == null ? [] : [share_properties.value.retention_policy]
        content {
          days = retention_policy.value.days
        }
      }
    }
  }
}
