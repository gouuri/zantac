variable "resource_group_name" {}
variable "location" {}
variable "tags" {}  
variable "admin_username" {}
variable "admin_password" {}
variable "subnet_id" {}


resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 numeric  = false
}

resource "azurerm_public_ip" "jumpbox" {
 name                         = "jumpbox-public-ip"
 location                     = var.location
 resource_group_name          = var.resource_group_name
 allocation_method            = "Static"
 domain_name_label            = "${random_string.fqdn.result}-ssh"
 tags                         = var.tags
}

resource "azurerm_network_interface" "jumpbox" {
 name                = "jumpbox-nic"
 location            = var.location
 resource_group_name = var.resource_group_name

 ip_configuration {
   name                          = "IPConfiguration"
   subnet_id                     = var.subnet_id
   private_ip_address_allocation = "Dynamic"
   public_ip_address_id          = azurerm_public_ip.jumpbox.id
 }

 tags = var.tags
}


resource "azurerm_virtual_machine" "jumpbox" {
 name                  = "jumpbox"
 location              = var.location
 resource_group_name   = var.resource_group_name
 network_interface_ids =  [azurerm_network_interface.jumpbox.id]
 vm_size               = "Standard_DS1_v2"

 storage_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_os_disk {
   name              = "jumpbox-osdisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 os_profile {
   computer_name  = "jumpbox"
   admin_username = var.admin_username
   admin_password = var.admin_password
 }

 os_profile_linux_config {
    ssh_keys  {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
    disable_password_authentication = false
   
 }

 tags = var.tags
}