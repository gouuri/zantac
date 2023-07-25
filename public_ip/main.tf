variable "resource_group_name" {}
variable "location" {}
variable "domain_name_label" {}
variable "tags" {}
variable "public_ip_name" {}

resource "azurerm_public_ip" "public_ip" {
 name                         = var.public_ip_name
 location                     = var.location
 resource_group_name          = var.resource_group_name
 allocation_method            = "Static"
 domain_name_label            = var.domain_name_label
 tags                         = var.tags
}

output "public_ip_vmss_id" {
    value = azurerm_public_ip.public_ip.id
}

output "public_ip_vmss_fqdn" {
    value = azurerm_public_ip.public_ip.fqdn
}

  

