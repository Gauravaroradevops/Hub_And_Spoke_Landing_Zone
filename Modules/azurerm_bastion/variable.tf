
variable "hub_bastion" {
  type = map(object({
    name                  = string
    location              = string
    resource_group_name   = string
    ip_configuration_name = string
    public_ip             = string
    subnet_name           = string
    virtual_network_name  = string
  }))
}

variable "tags" {
  type = map(string)
}
