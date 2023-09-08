terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.69.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

terraform {
  backend "azurerm" {
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "virtual_network" {
  source              = "./modules/virtual_network"
  name                = "${var.virtual_network_name}-${var.environment_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = []

  subnets = [
    {
      name : var.snet_agw_name
      address_prefix : var.snet_agt_address_prefix
      services_endpoint = []
    },
    {
      name : var.snet_vm_name
      address_prefix : var.snet_vm_address_prefix
      services_endpoint : []
    },
    {
      name : var.snet_bastion_name
      address_prefix : var.snet_bastion_address_prefix
      services_endpoint : []
    },
    {
      name : var.snet_key_vault_name
      address_prefix : var.snet_key_vault_address_prefix
      services_endpoint : []
    },
    {
      name : var.snet_storage_account_name
      address_prefix : var.snet_key_vault_address_prefix
      services_endpoint : []
    }
  ]
}

module "virtual_machine_linux" {
  source                = "./modules/virtual_machine_linux"
  agent_count           = var.agent_count
  name                  = "${var.linux_vm_name}-${var.environment_name}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  subnet_id             = module.virtual_network.id[var.snet_vm_name]
  size                  = var.size
  username              = var.username
  storage_account_type  = var.storage_account_type
}

module "virtual_machine_win" {
  source                = "./modules/virtual_machine_win"
  name                  = "${var.win_vm_name}-${var.environment_name}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  subnet_id             = module.virtual_network.id[var.snet_vm_name]
  size                  = var.size
  username              = var.username
  password              = var.password
  storage_account_type  = var.storage_account_type
}

module "aks" {
  source              = "./modules/aks"
  name                = "${var.aks_name}-${var.environment_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  node_count          = var.node_count
  vm_size             = var.size
  environment_name    = var.environment
}

module "storage_account" {
  source              = "./modules/storage_account"
  name                = "${var.storage_account_name}-${var.environment_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.virtual_network.id[var.snet_storage_account_name]
}

module "mssql" {
  source                       = "./modules/mssql"
  name                         = "${var.sql_server_name}-${var.environment_name}"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = var.version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  databases = [
    {
      name           : var.db_aks_name
      collation      : var.db_aks_colletion
      license_type   : var.db_aks_license_type
      max_size_gb    : var.db_aks_max_size_gb
      read_scale     : true
      sku_name       : var.db_aks_sku_name
      zone_redundant : true
    },
    {
      name           : var.db_apps_name
      collation      : var.db_apps_colletion
      license_type   : var.db_apps_license_type
      max_size_gb    : var.db_apps_max_size_gb
      read_scale     : true
      sku_name       : var.db_apps_sku_name
      zone_redundant : true
    }
  ]
}

module "application_gateway" {
  source               = "./modules/application_gateway"
  name                 = "${var.agw_name}-${var.environment_name}"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  subnet_id            = module.virtual_netwok.subnet_ids[var.snet_agw_name]
  virtual_network_name = module.virtual_network.name
  tier                 = var.tier
  capacity             = var.capacity
}

module "app_services" {
  source = "./modules/app_services"
}

module "key_vault" {
  source = "./modules/key_vault"
}