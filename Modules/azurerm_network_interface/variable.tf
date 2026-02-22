variable "nics" {
  type = map(object({
    nic_name             = string
    location             = string
    resource_group_name  = string
    subnet_name          = string
    virtual_network_name = string
    pip_name             = optional(string, null)
    ip_configuration = list(object({
      ip_name                       = string
      private_ip_address_allocation = string
      public_ip_address_id          = optional(string)
      private_ip_address            = string
    }))

    }
  ))
}



variable "tags" {
  type = map(string)

}
