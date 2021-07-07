terraform {
  required_version = "=1.0.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.60"
    }
  }
}

variable "rg_name" {
  type = string
  description = "Enter your resource group name"
  sensitive = true
}

variable "subscription_id" {
  type = string
  description = "Enter your subscrition id"
  sensitive = true
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name    = var.rg_name
  location = "eastus"
  tags = {
    provider = "azure"
  }
}