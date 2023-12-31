variable "resource_group_name" {}
variable "location" {}
variable "tags" {}  
variable "scale_set_name" {}
variable "admin_username" {}
variable "admin_password" {}
variable "subnet_id" {}
variable "bpepool_id" {}

resource "azurerm_virtual_machine_scale_set" "vmss" {
 name                = var.scale_set_name
 location            = var.location
 resource_group_name = var.resource_group_name
 upgrade_policy_mode = "Manual"

 sku {
   name     = "Standard_DS1_v2"
   tier     = "Standard"
   capacity = 2
 }

 storage_profile_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }
 

 storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

 os_profile {
   computer_name_prefix = "vmlab"
   admin_username       = var.admin_username
   admin_password       = var.admin_password
   #custom_data          = file("./vm_scaleset/web.conf")
   custom_data = <<-CLOUD_INIT
            #cloud-config
            package_upgrade: true
            packages:
              - nginx
            runcmd:
              - 'sed -i "s/80 default_server;/8080 default_server;/" /etc/nginx/sites-available/default'
              - 'systemctl restart nginx'
  CLOUD_INIT
 }

 os_profile_linux_config {
  ssh_keys  {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
    disable_password_authentication = false
 }

 network_profile {
   name    = "terraformnetworkprofile"
   primary = true

   ip_configuration {
     name                                   = "IPConfiguration"
     subnet_id                              = var.subnet_id
     load_balancer_backend_address_pool_ids = [var.bpepool_id]
     primary = true
   }
 }

 tags = var.tags
}