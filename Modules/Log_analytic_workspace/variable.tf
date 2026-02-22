variable "log_analytics_workspace" {
  type = map(object({
    workspace_name      = string
    location            = string
    resource_group_name = string
    sku                 = string
    retention_in_days   = string
    dcr_name            = string
    destination_name    = string
  }))
}
variable "tags" {
  type = map(string)
}