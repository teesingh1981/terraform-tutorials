# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
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
  name     = "example-nsg-rg"
  location = "uksouth"
}

resource "azurerm_network_security_group" "nsg_example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "web_port_80"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "192.168.0.1" # Source IP Address Office/Home IP Address 
    destination_address_prefix = "*" 
  }

  tags = {
    environment = "Test"
    role = "Test NSG Deployment"
  }
}