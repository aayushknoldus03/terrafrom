terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.2"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 1.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}