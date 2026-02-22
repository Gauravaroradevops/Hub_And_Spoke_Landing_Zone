resource "azurerm_key_vault" "kvs" {
  for_each = var.keyvault
  
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = each.value.sku_name

  soft_delete_retention_days = each.value.soft_delete_retention_days
  purge_protection_enabled   = each.value.purge_protection_enabled

  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment

  public_network_access_enabled = each.value.public_network_access_enabled
  rbac_authorization_enabled    = each.value.rbac_authorization_enabled

  tags = var.tags

  # ---------- Network ACLs ----------
  dynamic "network_acls" {
    for_each = each.value.network_acls == null ? [] : [each.value.network_acls]

    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  # ---------- Access Policies (only if not using RBAC) ----------
  dynamic "access_policy" {
    for_each = each.value.access_policies

    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id

      application_id          = access_policy.value.application_id
      key_permissions         = access_policy.value.key_permissions
      secret_permissions      = access_policy.value.secret_permissions
      certificate_permissions = access_policy.value.certificate_permissions
      storage_permissions     = access_policy.value.storage_permissions
    }
  }
}
resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  for_each            = var.keyvault
  scope               = azurerm_key_vault.kvs[each.key].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id        = data.azurerm_client_config.current.object_id
}
