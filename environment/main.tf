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

  ]
}

module "virtual_machine_linux" {
  source = "./modules/virtual_machine_linux"
}

module "virtual_machine_win" {
  source = "./modules/virtual_machine_win"
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