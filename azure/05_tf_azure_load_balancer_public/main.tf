provider "azurerm" { 
  features {}
}

resource "azurerm_resource_group" "rg_lb" {
  name     = "LoadBalancerRG"
  location = "uksouth"
}

resource "azurerm_public_ip" "lb_public_ip" {
  name                = "PublicIPForLB"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.rg_lb.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb_public" {
  name                = "TestLoadBalancer"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.rg_lb.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

# Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb

#resource "azurerm_resource_group" "example" {
#  name     = "LoadBalancerRG"
#  location = "West Europe"
#}
#
#resource "azurerm_public_ip" "example" {
#  name                = "PublicIPForLB"
#  location            = "West US"
#  resource_group_name = azurerm_resource_group.example.name
#  allocation_method   = "Static"
#}
#
#resource "azurerm_lb" "example" {
#  name                = "TestLoadBalancer"
#  location            = "West US"
#  resource_group_name = azurerm_resource_group.example.name
#
#  frontend_ip_configuration {
#    name                 = "PublicIPAddress"
#    public_ip_address_id = azurerm_public_ip.example.id
#  }
#}