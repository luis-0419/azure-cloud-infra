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
  source = "./modules/virtual_network"
  
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