variable "resource_group_name" {}
variable "location" {}
variable "lb_name" {}
variable "public_ip_id" {}
variable "tags" {}  
variable "application_port" {}
variable "backend_port" {}
  

resource "azurerm_lb" "pub_loadbalancer" {
 name                = var.lb_name
 location            = var.location
 resource_group_name = var.resource_group_name

 frontend_ip_configuration {
   name                 = "PublicIPAddress"
   public_ip_address_id = var.public_ip_id
 }

 tags = var.tags
}


resource "azurerm_lb_backend_address_pool" "bpepool" {
 loadbalancer_id     = azurerm_lb.pub_loadbalancer.id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lb_probe" {
 #resource_group_name = var.resource_group_name
 loadbalancer_id     = azurerm_lb.pub_loadbalancer.id
 name                = "ssh-running-probe"
 port                = var.backend_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  # resource_group_name            = var.resource_group_name
   loadbalancer_id                = azurerm_lb.pub_loadbalancer.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.backend_port
   backend_address_pool_ids        = [azurerm_lb_backend_address_pool.bpepool.id]
   frontend_ip_configuration_name = "PublicIPAddress"
   probe_id                       = azurerm_lb_probe.lb_probe.id

}

output "bpepool_id" {
  value = azurerm_lb_backend_address_pool.bpepool.id
}