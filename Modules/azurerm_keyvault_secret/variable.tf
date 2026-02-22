variable "kvs" {
  type = map(object({
    secret-name         = string
    resource_group_name = string
    key_vault_name      = string
    secret_type         = string
  }))
}