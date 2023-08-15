variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnets" {
  type = list(object({
    name              = string 
    address_prefix    = list(string)
    services_endpoint = list(string)
  }))
}