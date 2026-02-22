rgs = {
  "rg1" = { name = "dev-todo-rg", location = "centralindia" }
}
stgs = {
  "stg1" = { name = "devstga123141", resource_group_name = "dev-todo-rg", location = "centralindia", account_tier = "Standard", account_replication_type = "LRS", blob_properties = { versioning_enabled = true } }
}

vnets = {
  "vnet"      = { name = "Hub-vnet1", location = "centralindia", resource_group_name = "dev-todo-rg", address_space = ["20.0.0.0/16"], }
  "dev-vnet1" = { name = "dev-spoke-vnet1", location = "centralindia", resource_group_name = "dev-todo-rg", address_space = ["10.0.0.0/16"], }

}

subnets = {
  subnet1 = { name = "dev-frontend-subnet1", resource_group_name = "dev-todo-rg", virtual_network_name = "dev-spoke-vnet1", address_prefixes = ["10.0.1.0/24"], private_endpoint_network_policies = "Enabled",
  nsg_name = "nsg1" }
  subnet2 = { name = "dev-backend-subnet1", resource_group_name = "dev-todo-rg", virtual_network_name = "dev-spoke-vnet1", address_prefixes = ["10.0.2.0/24"], private_endpoint_network_policies = "Enabled",
  nsg_name = "nsg2" }
  subnet3 = { name = "dev-Database-subnet1", resource_group_name = "dev-todo-rg", virtual_network_name = "dev-spoke-vnet1", address_prefixes = ["10.0.3.0/28"] }
  subnet4 = { name = "AzureBastionSubnet", resource_group_name = "dev-todo-rg", virtual_network_name = "Hub-vnet1", address_prefixes = ["20.0.0.0/26"] }
  subnet5 = { name = "appgatewaysubnet", resource_group_name = "dev-todo-rg", virtual_network_name = "Hub-vnet1", address_prefixes = ["20.0.0.64/26"] }
  subnet6 = { name = "AzureFirewallSubnet", resource_group_name = "dev-todo-rg", virtual_network_name = "Hub-vnet1", address_prefixes = ["20.0.0.128/26"] }
}

keyvault = {
  "devkv1" = { name = "dev-kvault1-1", location = "centralindia", resource_group_name = "dev-todo-rg", soft_delete_retention_days = 7, purge_protection_enabled = false, sku_name = "standard" }
}

kvs = {
  "kvs1" = { secret-name = "fe-vm-user", secret_type = "adminuser", key_vault_name = "dev-kvault1-1", resource_group_name = "dev-todo-rg" }
  "kvs2" = { secret-name = "be-vm-user", secret_type = "adminuser", key_vault_name = "dev-kvault1-1", resource_group_name = "dev-todo-rg" }
  "kvs3" = { secret-name = "fe-vm-pass", secret_type = "adminuser@123", key_vault_name = "dev-kvault1-1", resource_group_name = "dev-todo-rg" }
  "kvs4" = { secret-name = "be-vm-pass", secret_type = "adminuser@123!", key_vault_name = "dev-kvault1-1", resource_group_name = "dev-todo-rg" }
  "kvs5" = { secret-name = "db-user", secret_type = "devdbadminuser!", key_vault_name = "dev-kvault1-1", resource_group_name = "dev-todo-rg" }
  "kvs6" = { secret-name = "db-pass", secret_type = "adminuser@!123@@@", key_vault_name = "dev-kvault1-1", resource_group_name = "dev-todo-rg" }
}
pips = {
  "pip1" = { name = "Bastion-pip", location = "centralindia", resource_group_name = "dev-todo-rg", allocation_method = "Static" }
  "pip2" = { name = "Firewall-pip", location = "centralindia", resource_group_name = "dev-todo-rg", allocation_method = "Static" }
  "pip3" = { name = "agw-pip", location = "centralindia", resource_group_name = "dev-todo-rg", allocation_method = "Static" }
}

nsgs = {
  "nsg1" = { nsg_name = "dev-fe-nsg1", location = "centralindia", resource_group_name = "dev-todo-rg",
    security_rule = [
      { rule_name = "dev-fe-inbound1", priority = "100", direction = "Inbound", access = "Allow", protocol = "Tcp",
      source_port_range = "*", destination_port_range = "*", source_address_prefix = "*", destination_address_prefix = "*" },

      { rule_name = "dev-fe-Outbound1", priority = "100", direction = "Outbound", access = "Allow", protocol = "Tcp",
      source_port_range = "*", destination_port_range = "*", source_address_prefix = "*", destination_address_prefix = "*" }
    ]
  }

  "nsg2" = { nsg_name = "dev-be-nsg1", location = "centralindia", resource_group_name = "dev-todo-rg",
    security_rule = [
      { rule_name = "dev-be-Inbound1", priority = "102", direction = "Inbound", access = "Allow", protocol = "Tcp",
      source_port_range = "*", destination_port_range = "*", source_address_prefix = "*", destination_address_prefix = "*" },

      { rule_name = "dev-be-Outbound1", priority = "102", direction = "Outbound", access = "Allow", protocol = "Tcp",
      source_port_range = "*", destination_port_range = "*", source_address_prefix = "*", destination_address_prefix = "*" },
    ]
  }
}


# #pip_name = "" in nic block & public_ip_address_id = "nic-key" in ip_configuration req in case to associate public ip

nics = {
  "nic1" = { nic_name = "dev-fe-nic1", location = "centralindia", resource_group_name = "dev-todo-rg", #pip_name = "dev-pip1"
    subnet_name = "dev-frontend-subnet1", virtual_network_name = "dev-spoke-vnet1"
    ip_configuration = [{ ip_name = "dev-fe-ip1", private_ip_address_allocation = "Static", private_ip_address = "10.0.1.10" #public_ip_address_id = "nic1" 
    }]
  }
  "nic2" = { nic_name = "dev-be-nic1", location = "centralindia", resource_group_name = "dev-todo-rg", #pip_name = "dev-pip2", 
    subnet_name = "dev-backend-subnet1", virtual_network_name = "dev-spoke-vnet1"
    ip_configuration = [{ ip_name = "dev-be-ip2", private_ip_address_allocation = "Static", private_ip_address = "10.0.2.20", #public_ip_address_id = "nic2" 
    }]
  }
  # "nic3" = { nic_name = "lb-pvt-ip", location = "centralindia", resource_group_name = "dev-todo-rg",
  #   subnet_name      = "dev-backend-subnet1", virtual_network_name = "dev-spoke-vnet1"
  #   ip_configuration = [{ ip_name = "lb-pvt-ip2", private_ip_address_allocation = "Static", private_ip_address = "10.0.2.30" }]
  # }
}
sql_s = {
  "sql_s1" = { name = "sql-server-dev1p", resource_group_name = "dev-todo-rg", location = "centralindia", version = "12.0", minimum_tls_version = "1.2", key_vault_name = "dev-kvault1-1", secret_name = "db-user", secret_type = "db-pass" }
}
sqldb = {
  "sqldb1" = { name = "devsqldbfortodo", sql_server_name = "sql-server-dev1p", resource_group_name = "dev-todo-rg" }
}

pe_point = {
  "pe_point1" = { name = "sqldb_spoke_pe", location = "centralindia", resource_group_name = "dev-todo-rg",
    subnet_name                     = "dev-Database-subnet1", virtual_network_name = "dev-spoke-vnet1",
    private_service_connection_name = "sqldbprivateserviceconnection", sql_server_name = "sql-server-dev1p",
    vnet_name                       = "dev-spoke-vnet1", vnet_resource_group_name = "dev-todo-rg", private_dns_zone_group = "sqldb_dns_zone_group",
    subresource_names               = ["sqlServer"], is_manual_connection = false, db_dns_name = "privatelink.database.windows.net",
  sqldb_dns_vnet_link = "sqldb_dns_vnet_link" }
}

vms = {
  "fe-vm1" = { name = "dev-frontend-vm1", resource_group_name = "dev-todo-rg", location = "centralindia", size = "Standard_D2s_v5",
    caching = "ReadWrite", storage_account_type = "Standard_LRS", publisher = "canonical", offer = "ubuntu-24_04-lts",
    sku     = "ubuntu-pro-gen1", version = "latest", key_vault_name = "dev-kvault1-1", secretu_name = "fe-vm-user", secretp_name = "fe-vm-pass", nic_name = "dev-fe-nic1",
    lun     = "30", disk_name = "dev-fe-vm1-disk", create_option = "Empty", disk_size_gb = "10", custom_data = "nginx.sh"
  }

  "be-vm1" = { name = "dev-backend-vm1", resource_group_name = "dev-todo-rg", location = "centralindia", size = "Standard_D2s_v5",
    caching = "ReadWrite", storage_account_type = "Standard_LRS", publisher = "canonical", offer = "ubuntu-24_04-lts",
    sku     = "ubuntu-pro-gen1", version = "latest", key_vault_name = "dev-kvault1-1", secretu_name = "be-vm-user", secretp_name = "be-vm-pass", nic_name = "dev-be-nic1",
    lun     = "30", disk_name = "dev-be-vm1-disk", create_option = "Empty", disk_size_gb = "10", custom_data = "python.sh"
  }

}

lbs = {
  "Ilb1" = { name = "dev-internal-load-balancer", location = "centralindia", resource_group_name = "dev-todo-rg", be_vm_nic_ip_conf_name = "dev-be-ip2", lb_private_ip = "10.0.2.30", lb_b_pool = "dev-be-vm-pool"
    lb_rule_name                  = "dev-lb-rule", protocol = "Tcp", frontend_port = 8000, backend_port = 8000, lb_probe_name = "dev-prob", lb_probe_port = 8000, be_vm_nic_names = ["dev-be-nic1", ]
    subnet_name                   = "dev-backend-subnet1"
    virtual_network_name          = "dev-spoke-vnet1"
    private_ip_address_allocation = "Static"
    fip_conf_name                 = "lb_ip_conf"
  }
}


hub_bastion = {
  "hub_bastion1" = {
    name                  = "hub_bastion"
    location              = "centralindia"
    resource_group_name   = "dev-todo-rg"
    ip_configuration_name = "hub_ip"
    public_ip             = "Bastion-pip"
    subnet_name           = "AzureBastionSubnet"
    virtual_network_name  = "Hub-vnet1"

  }
}

peering = {
  "vnetA-B" = {
    name                 = "Hub-vnet1-to-dev-spoke-vnet1"
    resource_group_name  = "dev-todo-rg"
    virtual_network_name = "Hub-vnet1"
    remote_vnet_name     = "dev-spoke-vnet1"
  }
  "vnetB-A" = {
    name                 = "dev-spoke-vnet1-to-Hub-vnet1"
    resource_group_name  = "dev-todo-rg"
    virtual_network_name = "dev-spoke-vnet1"
    remote_vnet_name     = "Hub-vnet1"
  }
}

appgateway = {
  "c1agw" = {
    appgateway_name                        = "centralindiaagw"
    resource_group_name                    = "dev-todo-rg"
    location                               = "centralindia"
    sku_name                               = "Standard_v2"
    sku_tier                               = "Standard_v2"
    sku_capacity                           = "10"
    gateway_ip_name                        = "gateway_ip"
    subnet_name                            = "appgatewaysubnet"
    virtual_network_name                   = "Hub-vnet1"
    frontend_port_number                   = 80
    agw_pip_name                           = "agw-pip"
    private_ip_address                     = "20.0.0.70"
    private_ip_address_allocation          = "Static"
    frontend_port_name                     = "agw_fe_port"
    frontend_ip_configuration_name         = "agw_fe_ip_name"
    private_frontend_ip_configuration_name = "agw_pvt_fe_ip_name"

    backend_address_pool = [
      { ip_addresses = ["10.0.1.10"], backend_address_pool_name = "blue" },
    ]
    backend_http_settings = [
      { http_setting_name = "blueenv", cookie_based_affinity = "Disabled",
      path = "/", backend_pool_port = 80, protocol = "Http", request_timeout = 60 },
    ]
    http_listener = [
      { listener_name = "http_listner", frontend_ip_configuration_name = "agw_fe_ip_name", listner_protocol = "Http", host_name = "ui.puneetdevops.online",
      frontend_port_name = "agw_fe_port" },
      { listener_name = "http_listner_pvt", frontend_ip_configuration_name = "agw_pvt_fe_ip_name", listner_protocol = "Http", host_name = "ui.puneetdevops.online",
      frontend_port_name = "agw_fe_port" },
    ]
    request_routing_rule = [
      { priority                   = 100, rule_type = "Basic", backend_address_pool_name = "blue"
        backend_http_settings_name = "blueenv", request_routing_rule_name = "blue_rue",
      listener_name = "http_listner" },

      { priority                   = 101, rule_type = "Basic", backend_address_pool_name = "blue"
        backend_http_settings_name = "blueenv", request_routing_rule_name = "blue_pvt_rue",
      listener_name = "http_listner_pvt" },

    ]
  }
}

log_analytics_workspace = {
  "LAW" = {
    dcr_name            = "data_collection_rule"
    workspace_name      = "LAWorkspace"
    location            = "centralindia"
    resource_group_name = "dev-todo-rg"
    retention_in_days   = "30"
    sku                 = "PerGB2018"
    destination_name    = "law-destination"
  }
}

firewall = {
  "hub-firewall" = {
    firewall_name        = "hub_firewall"
    location             = "centralindia"
    resource_group_name  = "dev-todo-rg"
    sku_name             = "AZFW_VNet"
    sku_tier             = "Standard"
    firewall_ip_name     = "fw-ipconfig"
    firewall_subnet_name = "AzureFirewallSubnet"
    virtual_network_name = "Hub-vnet1"
    firewall_pip_name    = "Firewall-pip"

    nat_rules = [
      {
        name               = "dnat-http"
        source_addresses   = ["*"]
        destination_ports  = ["80"]
        translated_port    = 80
        translated_address = "20.0.0.70"
        protocols          = ["TCP"]
      }
    ]

    network_rules = [
      {
        name                  = "allow-http-https"
        source_addresses      = ["10.0.1.0/24"]
        destination_ports     = ["80", "443"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
      },
      {
        name                  = "allow-http-https-subnet2"
        source_addresses      = ["10.0.2.0/24"]
        destination_ports     = ["80", "443"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
      },
      {
        name                  = "allow-http-https-subnet3"
        source_addresses      = ["10.0.3.0/28"]
        destination_ports     = ["80", "443"]
        destination_addresses = ["*"]
        protocols             = ["TCP"]
      },
    ]
  }
}

route_table = {
  "route_table1 " = {
    route_table_name     = "udr_subnet1"
    location             = "centralindia"
    resource_group_name  = "dev-todo-rg"
    subnet_name          = "dev-frontend-subnet1"
    virtual_network_name = "dev-spoke-vnet1"
    firewall_name        = "hub_firewall"
    route = [{
      address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", route_name = "subnet1-to-firewall" }
    ]
  }
  "route_table1=2 " = {
    route_table_name     = "udr_subnet2"
    location             = "centralindia"
    resource_group_name  = "dev-todo-rg"
    subnet_name          = "dev-backend-subnet1"
    virtual_network_name = "dev-spoke-vnet1"
    firewall_name        = "hub_firewall"
    route = [{
      address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", route_name = "subnet2-to-firewall" }
    ]
  }
  "route_table1=3 " = {
    route_table_name     = "udr_subnet3"
    location             = "centralindia"
    resource_group_name  = "dev-todo-rg"
    subnet_name          = "dev-Database-subnet1"
    virtual_network_name = "dev-spoke-vnet1"
    firewall_name        = "hub_firewall"
    route = [{
      address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", route_name = "subnet3-to-firewall" }
    ]
  }
}
