variable "lbs" {
  type = map(object({
    name                          = string
    location                      = string
    resource_group_name           = string
    fip_conf_name                 = string
    lb_b_pool                     = string
    lb_rule_name                  = string
    protocol                      = string
    frontend_port                 = number
    backend_port                  = number
    lb_probe_name                 = string
    lb_probe_port                 = number
    lb_private_ip                 = string
    subnet_name                   = string
    virtual_network_name          = string
    private_ip_address_allocation = string
    be_vm_nic_ip_conf_name        = string
    be_vm_nic_names               = list(string)
  }))
}
