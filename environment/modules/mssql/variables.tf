variable "databases" {
  type = list(object({
    name           = string
    collation      = string
    license_type   = string
    max_size_gb    = number
    read_scale     = bool
    sku_name       = string
    zone_redundant = bool
  }))
}