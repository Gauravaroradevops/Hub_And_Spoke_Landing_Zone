resource "azurerm_log_analytics_workspace" "law" {
  for_each                = var.log_analytics_workspace
  name                    = each.value.workspace_name
  location                = each.value.location
  resource_group_name     = each.value.resource_group_name
  sku                     = each.value.sku
  retention_in_days       = each.value.retention_in_days
  tags                    = var.tags
}



resource "azurerm_monitor_data_collection_rule" "dcr" {
  for_each                    = var.log_analytics_workspace
  name                        = each.value.dcr_name
  resource_group_name         = each.value.resource_group_name
  location                    = each.value.location
  


  # it sends all syslogs and sys performance to LAW
  data_flow {
    streams      = ["Microsoft-Syslog", "Microsoft-Perf"]
    destinations = ["law-destination"]
  }

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.law[each.key].id
      name                  = each.value.destination_name
    }
    # event_hub {
    #   event_hub_id = azurerm_eventhub.example.id
    #   name         = "example-destination-eventhub"
    # }

    # storage_blob {
    #   storage_account_id = azurerm_storage_account.example.id
    #   container_name     = azurerm_storage_container.example.name
    #   name               = "example-destination-storage"
    # }

  }
  # what data will be collected from targetd vms
  data_sources {
    syslog {
      facility_names = ["*"]
      log_levels     = ["*"]
      name           = "datasource-syslog"
      streams        = ["Microsoft-Syslog"]
    }

    # it will collect data in every 60 seconds
    performance_counter {
      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["Processor(*)\\% Processor Time"]
      name                          = "example-datasource-perfcounter"
    }
  }
}




