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
  name                = var.virtual_network_name
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
    }
  ]
}

module "virtual_machine_linux" {
  source                = "./modules/virtual_machine_linux"
  agent_count           = var.agent_count
  name                  = var.linux_vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  subnet_id             = module.virtual_network.id[var.snet_vm_name]
  size                  = var.size
  username              = var.username
  storage_account_type  = var.storage_account_type
}

module "virtual_machine_win" {
  source                = "./modules/virtual_machine_win"
  name                  = var.win_vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  subnet_id             = module.virtual_network.id[var.snet_vm_name]
  size                  = var.size
  username              = var.username
  password              = var.password
  storage_account_type  = var.storage_account_type
}

module "aks" {
  source = "./modules/aks"
}

module "storage_account" {
  source = "./modules/storage_account"
}

module "mssql" {
  source = "./modules/mssql"
}

module "application_gateway" {
  source = "./modules/application_gateway"
}

module "app_services" {
  source = "./modules/app_services"
}

module "key_vault" {
  source = "./modules/key_vault"
}