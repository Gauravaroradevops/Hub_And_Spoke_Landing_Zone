variable "sql_s" {
  sensitive = true
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    version             = string
    minimum_tls_version = string
    key_vault_name      = string
    secret_name         = string
    secret_type         = string
  }))
}
variable "tags" {
  type = map(string)
}
