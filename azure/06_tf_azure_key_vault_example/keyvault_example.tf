terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.91.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "taj_poc"
  location = "uksouth"
  tags = {
    creator = "Terraform"
    project = "keyvault-example-rg"
    role    = "test-poc"
  }
}

resource "azurerm_key_vault" "azvault" {
  name                        = "taj01vault1"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  tags = {
    creator = "Terraform"
    project = "keyvault-example"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get", "create", "list", "update",
    ]

    secret_permissions = [
      "get", "list", "set"
    ]

    storage_permissions = [
      "get", "list", "set", "update",
    ]
  }
}