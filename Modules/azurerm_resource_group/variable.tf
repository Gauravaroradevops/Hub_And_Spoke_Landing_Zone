variable "rgs" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
  }))
}

variable "tags" {
    type = map(string)
}