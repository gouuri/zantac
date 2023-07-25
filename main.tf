provider "azurerm" {
  features {}
}

resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 numeric  = false
}
# Creating Resource Group
module "rg" {
  source              = "./resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  
}

# Creating Virtual Network, Subnet, Address Space
module "vnet" {
  source = "./vnet"

  vnet_name             = var.vnet_name
  address_space         = var.address_space
  location              = module.rg.resource_group_location
  resource_group_name   = module.rg.resource_group_name
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
}

module "public_ip" {
  source = "./public_ip"
  #for_each = var.public_ip_name

  public_ip_name               = var.public_ip_name
  location                     = module.rg.resource_group_location
  resource_group_name          = module.rg.resource_group_name
  domain_name_label            = random_string.fqdn.result
  tags                         = var.tags
}

module "pub_loadbalancer" {
  source = "./loadbalancer"
  lb_name = var.lb_name
  public_ip_id = module.public_ip.public_ip_vmss_id
  location = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name
  tags = var.tags  
  application_port = var.application_port
  backend_port = var.backend_port
}

module "vmss" {
  source = "./vm_scaleset"
  location = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name
  tags = var.tags 
  scale_set_name = "demo-vmss" # need to change
  admin_username ="webpoweruser"
  admin_password = "G0dthankyou"
  subnet_id = module.vnet.subnet_id
  bpepool_id = module.pub_loadbalancer.bpepool_id
}

module "jumpbox" {
  source = "./vm"
  location = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name
  tags = var.tags 
  admin_username ="rootadmin"
  #admin_password = "XXXX"
  subnet_id = module.vnet.subnet_id
}

module "iam"{
  source ="./iam"
  displayname = "Web Powerusers"
  #password = "XXXXX"
  emailid = "webpwrusers@gouurishankarLIVE.onmicrosoft.com"
}