data "azurerm_subnet" "network_subnet_id" {
  for_each             = var.nics
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
data "azurerm_public_ip" "network_pip_data" {
  for_each             = {for k,v in var.nics :k => v if v.pip_name != null } # pip_name required argument to skip it this eq allow nic to skip this block if condition not meet (pip_name not available)
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
}
