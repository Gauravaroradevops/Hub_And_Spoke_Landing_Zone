resource "azurerm_linux_virtual_machine" "vms" {
  for_each                        = var.vms
  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = data.azurerm_key_vault_secret.vm_kvsdvm[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.vm_kvsdtvm[each.key].value
  network_interface_ids           = [data.azurerm_network_interface.vm_nic_d[each.key].id, ]
  custom_data                     = filebase64(each.value.custom_data)
  disable_password_authentication = false
  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
  tags = var.tags
}


resource "azurerm_managed_disk" "managed_disk" {
  for_each             = var.vms
  name                 = each.value.disk_name
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option #(empty to create a new disk or attach to attach a new disk)
  disk_size_gb         = each.value.disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_vm_attach" {
  for_each           = var.vms
  managed_disk_id    = azurerm_managed_disk.managed_disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.vms[each.key].id
  lun                = each.value.lun
  caching            = each.value.caching
}

resource "azurerm_virtual_machine_extension" "ama" {
  for_each                   = var.vms
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vms[each.key].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.27"
  auto_upgrade_minor_version = true
}

resource "azurerm_monitor_data_collection_rule_association" "DCRA" {
  for_each                = var.vms
  name                    = "DCRA"
  target_resource_id      = azurerm_linux_virtual_machine.vms[each.key].id
  data_collection_rule_id = data.azurerm_monitor_data_collection_rule.vm_dcrd[each.key].id
}

