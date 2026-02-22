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

variable "tags" {
  type = map(string)
}
