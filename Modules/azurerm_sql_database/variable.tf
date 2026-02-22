variable "tags" {
  type = map(string)
}

variable "sqldb" {
  type = map(object({
    sql_server_name     = string
    resource_group_name = string
    name                = string
    collation           = optional(string)
    license_type        = optional(string)
    max_size_gb         = optional(string)
    sku_name            = optional(string)
    enclave_type        = optional(string)
  }))
}
