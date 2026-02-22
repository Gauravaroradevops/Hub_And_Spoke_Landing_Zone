module "resource_groups" {
  source = "../../Modules/azurerm_resource_group"
  rgs    = var.rgs
  tags   = local.common_tags
}

module "storage_account" {
  depends_on = [module.resource_groups]
  source     = "../../Modules/azurerm_storage_Account"
  stgs       = var.stgs
  tags       = local.common_tags
}

module "vnets" {
  depends_on = [module.resource_groups]
  source     = "../../Modules/azurerm_virtual_network"
  vnets      = var.vnets
  tags       = local.common_tags
}
module "subnet" {
  depends_on = [module.vnets]
  source     = "../../Modules/azurerm_subnet"
  subnets    = var.subnets
  tags       = local.common_tags
  nsg_ids    = module.network_security_grouop.nsg_ids
}

module "keyvault" {
  depends_on = [module.resource_groups]
  source     = "../../Modules/azurerm_key_vault"
  keyvault   = var.keyvault
  tags       = local.common_tags
}
module "keyvault_secret" {
  depends_on = [module.resource_groups, module.keyvault]
  source     = "../../Modules/azurerm_keyvault_secret"
  kvs        = var.kvs
}
module "pips" {
  depends_on = [module.resource_groups, ]
  source     = "../../Modules/azurerm_public_ip"
  pips       = var.pips
  tags       = local.common_tags
}
module "network_security_grouop" {
  depends_on = [module.resource_groups]
  source     = "../../Modules/network_security_group"
  nsgs       = var.nsgs
  tags       = local.common_tags
}
module "network_interface_name" {
  depends_on = [module.pips, module.subnet]
  source     = "../../Modules/azurerm_network_interface"
  nics       = var.nics
  tags       = local.common_tags
}
module "sql_server" {
  depends_on = [module.resource_groups, module.subnet, module.keyvault_secret]
  source     = "../../Modules/azurerm_sql_server"
  sql_s      = var.sql_s
  tags       = local.common_tags
}
module "sql_database" {
  depends_on = [module.resource_groups, module.sql_server]
  source     = "../../Modules/azurerm_sql_database"
  sqldb      = var.sqldb
  tags       = local.common_tags

}

module "private_end_point" {
  depends_on = [module.resource_groups, module.vnets, module.subnet, module.sql_server, module.sql_database]
  source     = "../../Modules/azurerm_private_end_point"
  pe_point   = var.pe_point
}
module "azurerm_virtual_machine" {
  depends_on = [module.keyvault_secret, module.firewall, module.resource_groups, module.network_interface_name, module.network_security_grouop, module.pips, module.network_security_grouop, module.subnet, module.log_analytics_workspace]
  source     = "../../Modules/azurerm_virtual_machine"
  vms        = var.vms
  tags       = local.common_tags
}
module "frontend_load_balancer" {
  depends_on = [module.resource_groups, module.subnet, module.pips, module.azurerm_virtual_machine, module.network_interface_name]
  source     = "../../Modules/terraform_azurerm_load_balancer"
  lbs        = var.lbs
}

module "hub_bastion" {
  depends_on  = [module.resource_groups, module.pips, module.subnet]
  source      = "../../Modules/azurerm_bastion"
  hub_bastion = var.hub_bastion
  tags        = local.common_tags
}

module "vnet_peering" {
  source     = "../../Modules/vnet_peering"
  depends_on = [module.vnets]
  peering    = var.peering
}

module "appgateway" {
  source     = "../../Modules/azurerm_application_gateway"
  appgateway = var.appgateway
  depends_on = [module.resource_groups, module.subnet, module.pips]
  tags       = local.common_tags
}
output "pip" {
  value = module.pips.pip_address
}

module "log_analytics_workspace" {
  depends_on              = [module.resource_groups]
  source                  = "../../Modules/Log_analytic_workspace"
  tags                    = local.common_tags
  log_analytics_workspace = var.log_analytics_workspace
}

module "firewall" {
  depends_on = [module.resource_groups, module.appgateway, module.pips, module.subnet]
  source     = "../../Modules/azurerm_firewall"
  firewall   = var.firewall
  tags       = local.common_tags
}

module "route_table" {
  depends_on  = [module.resource_groups, module.subnet, module.firewall]
  source      = "../../Modules/azurerm_udr"
  route_table = var.route_table

}
