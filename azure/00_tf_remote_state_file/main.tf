provider "azurerm" { 
  features {}
}
terraform {
  backend "azurerm" {
    resource_group_name      = "tf"
    storage_account_name     = "tfstate01teesingh"
    container_name           = "terraform"
    key                      = "terraform.tfstate"
  }
}
resource "azurerm_resource_group" "rg"{
    name = "rg_test"
    location = "uksouth"
    tags = {
        enviroment = "terraform-test"
    }
}
