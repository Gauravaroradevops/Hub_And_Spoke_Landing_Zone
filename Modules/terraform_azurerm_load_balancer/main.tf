resource "azurerm_lb" "lbs" {
  for_each            = var.lbs
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  frontend_ip_configuration {
    name                          = each.value.fip_conf_name
    private_ip_address            = each.value.lb_private_ip
    subnet_id                     = data.azurerm_subnet.lb_subnet_data[each.key].id
    private_ip_address_allocation = each.value.private_ip_address_allocation
  }
}
resource "azurerm_lb_backend_address_pool" "lb_b_pool" {
  for_each        = var.lbs
  loadbalancer_id = azurerm_lb.lbs[each.key].id
  name            = each.value.lb_b_pool
}


resource "azurerm_lb_rule" "lb_rule_name" {
  for_each                       = var.lbs
  loadbalancer_id                = azurerm_lb.lbs[each.key].id
  name                           = each.value.lb_rule_name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.fip_conf_name
  probe_id                       = azurerm_lb_probe.lb_probe[each.key].id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_b_pool[each.key].id]
}


resource "azurerm_lb_probe" "lb_probe" {
  for_each        = var.lbs
  loadbalancer_id = azurerm_lb.lbs[each.key].id
  name            = each.value.lb_probe_name
  port            = each.value.lb_probe_port
}
resource "azurerm_network_interface_backend_address_pool_association" "nic_pool_a" {
  for_each                = data.azurerm_network_interface.lb_nicdata
  network_interface_id    = each.value.id
  ip_configuration_name   = each.value.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_b_pool["Ilb1"].id
}
