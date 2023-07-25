variable "resource_group_name" {
  default = "my-resource-gsp"
}
variable "location" {
  default = "East US"
}
# variable "resource_group_name_2" {
#   default = "my-resource-grp-2"
# }
variable "location_2" {
  default = "East US"
}
variable "vnet_name" {
  default = "my-vnet"
}
variable "subnet_name" {
  default = "my-subnet"
}
variable "address_space" {
  default = ["10.0.0.0/16"]
}
variable "subnet_address_prefix" {
  default = ["10.0.1.0/24"]
}
variable "tags" {
  type        = map(string)
   default = {
      environment = "dev"
   }
}

variable "public_ip_name" {
  description = "Public IP Name"
  
  default = "vmss-public-ip"
   #jumpbox = "jumpbox-public-ip"
  #}
}
variable "lb_name" {
  default = "public_loadbalancer"
}
variable "application_port" {
   description = "Port that you want to expose to the external load balancer"
   default     = 80
}
variable "backend_port" {
   description = "Port that you want to expose to the external load balancer"
   default     = 8080
}