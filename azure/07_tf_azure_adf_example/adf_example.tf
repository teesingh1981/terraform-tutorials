terraform {
  required_version = ">=0.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

# Uncomment below for remote TF statefile - you will need to create the relevant storage account name etc 
#    backend "azurerm" {
#      resource_group_name = "terraform-backend"
#      storage_account_name = "terraform-storage-01"
#      container_name = "tfstate"
#      key = "terraform.state"
#    }

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "tf-demo-adf"
  location = "uksouth"
  tags = {
    creator = "Terraform"
    project = "adf-example-rg"
    role = "Test-PoC"
  }
}

resource "azurerm_data_factory" "tf-adf" {
  name                = "tf-adf-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    creator = "Terraform"
    project = "adf-example"
  }
}




