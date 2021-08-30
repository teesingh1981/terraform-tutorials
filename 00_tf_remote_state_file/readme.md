### Terraform Remote State File Management

# Pre-Requisites 

# 01 - Azure Account with Admin Access

# 02 - Create A Resouce Group (tf) & Azure Storage Account (tfdemosa01abc) With A Container (terraform)

# 03 - Create a main.tf file with the following code

provider "azurerm" { 
  features {}
}
terraform {
  backend "azurerm" {
    resource_group_name      = "TF"
    storage_account_name     = "tfdemosa01abc"
    container_name           = "terraform"
    key                      = "terraform.tfstate"
  }
}
resource "azurerm_resource_group" "rg"{
    name = "rg_test"
    location = "uksouth"
    tags = {
        enviroment = "terraform-remote-state-file"
    }
}

# 04 - Commands to run

terraform init

terraform validate

terraform plan

terraform apply

# 05 - View state file (optional)

terraform state pull

# 06 - Clean-up

terraform destroy
