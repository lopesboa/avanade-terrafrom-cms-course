 ################################################### CONFIGURAÇÕES ###################################################
terraform {
   required_version = "=1.0.1"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.46"
    }
  }
  # backend "azurerm" {
  #   resource_group_name = "NetworkWatcherRG"
  #   storage_account_name = "cursoterraformcms"
  #   access_key = "key"
  #   container_name = "terraform"
  #   key = "./aula1.tfstate"
  # }
}

provider "azurerm" {
  features {}
  #alias = "avanade"
  subscription_id = var.subscription_id
}
# provider "azurerm" {
#   features {}
#   alias = "personal"
#   subscription_id = "<subscription>"
# }
########################################################## VARIAVEIS ##############################################
variable "subscription_id" {
  type = string
  description = "Enter your subscrition id"
  sensitive = true
}
variable "rg_name" {
  type = string
  description = "Nome dado ao resource group."
}
variable "tags" {
  type = map
  default = {}
}
variable "location" {
  type = string
  description = "definição de qual região o recurso será provisionado."
}
######################################################### RECURSOS #################################################
resource "azurerm_resource_group" "rg" {
  name = var.rg_name
  location = var.location
  tags = var.tags
}

module "aula2vnet" {
  source = "./vnet"
  vnet_name = "aula2vnet"
  address_space = [ "10.0.0.0/16" ]
  address_prefixes = [ "10.0.2.0/24" ]
  location = var.location
  rg_name = azurerm_resource_group.rg.name
}
module "aula2vnet2" {
  source = "./vnet"
  vnet_name = "aula2vnet2"
  address_space = [ "10.0.0.0/16" ]
  address_prefixes = [ "10.0.2.0/24" ]
  location = var.location
  rg_name = azurerm_resource_group.rg.name
}

# resource "azurerm_virtual_network" "vnet" {
#   name = "vnet-aula1"
#   address_space = [ "10.0.0.0/16" ]
#   location = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }
# resource "azurerm_subnet" "subnet" {
#   name = "interna"
#   resource_group_name = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes = [ "10.0.2.0/24" ]
# }
# resource "azurerm_network_interface" "nic" {
#   name = "nic-01"
#   location = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   ip_configuration {
#     name = "interna"
#     subnet_id = module.aula2vnet.subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

module "lnx-vm" {
  source = "git::https://github.com/msantanajunior/az-module-vm"
  name = "aula2terraform"
  location = azurerm_resource_group.rg.location
  rg_name = azurerm_resource_group.rg.name
  os_image = {
    sku = "8.2"
  }
  nics = {
    nic1 = {
      subnet_id = module.aula2vnet.subnet_id
      enable_accelerated_networking = "true"
      primary = "true"
    }
    nic2 = {
      subnet_id = module.aula2vnet.subnet_id
      enable_accelerated_networking = "true"
      primary = "true"
    }
  }
}

# resource "azurerm_windows_virtual_machine" "vm" {
#   name = "teste"
#   resource_group_name = azurerm_resource_group.rg.name
#   location = azurerm_resource_group.rg.location
#   network_interface_ids = [ azurerm_network_interface.nic.id ]
#   admin_username = "iacadmin"
#   admin_password = "P@$$w0rd1234!"
#   size = "Standard_F2"
#   os_disk {
#     caching = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer = "WindowsServer"
#     sku = "2016-Datacenter"
#     version = "latest"
#   }
# }
######################################################### SAÍDAS ###################################################
output "rg_id" {
  value = azurerm_resource_group.rg.id
}
output "rg_tags" {
  value = azurerm_resource_group.rg.tags
}