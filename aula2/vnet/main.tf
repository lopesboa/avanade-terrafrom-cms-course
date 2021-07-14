variable "rg_name" {
  type = string
  description = "(optional) describe your variable"
}
variable "address_prefixes" {
  type = list
  description = "(optional) describe your variable"
}
variable "address_space" {
  type = list
  description = "(optional) describe your variable"
}
variable "location" {
  type = string
  description = "(optional) describe your variable"
}
variable "vnet_name" {
  type = string
  description = "(optional) insert your vnet name"
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  address_space = var.address_space
  location = var.location
  resource_group_name = var.rg_name
}
resource "azurerm_subnet" "subnet" {
  name = "interna"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.address_prefixes
}

output "subnet_id" {
  value =  azurerm_subnet.subnet.id
}