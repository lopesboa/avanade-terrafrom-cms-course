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

provider "azurerm" {
  features {}
  subscription_id = "ddbb2596-0ed0-44f5-9853-8855ceb1b75b"
}

resource "azurerm_resource_group" "rg" {
  name    = "aulaiaccms"
  location = "eastus"
  tags = {
    provider = "azure"
  }
}