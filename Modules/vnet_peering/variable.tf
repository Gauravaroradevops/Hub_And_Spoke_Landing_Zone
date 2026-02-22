variable "peering" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    remote_vnet_name     = string
  }))

}