provider "azurerm" {
  features {}
}
variable "vnet_name" {type = string}
variable "address_space" { type = list(string) }
variable "location" {}
variable "resource_group_name" {}
variable "subnet_name" {}
variable "subnet_address_prefix" {}


resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  # address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_subnet" "main" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefix
}
