variable "pips" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    allocation_method   = string
  }))
}
variable "tags" {
    type = map(string)
}