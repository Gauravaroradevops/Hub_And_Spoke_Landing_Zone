data "azurerm_network_interface" "lb_nicdata" {
  for_each            = toset(var.lbs["Ilb1"].be_vm_nic_names)
  name                = each.value
  resource_group_name = "dev-todo-rg"
}
data "azurerm_subnet" "lb_subnet_data" {
  for_each             = var.lbs
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
