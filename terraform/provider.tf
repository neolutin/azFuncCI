#Set the terraform required version
terraform {
  required_version = "~> 1.0"
  backend "azurerm" {
    storage_account_name = "saterraformneolutin"
    container_name       = "azfuncci"
    key                  = "dev01/terraform.tfstate"
    access_key           = "${{ secrets.terraformstoragekey }}"
  }
}

# Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = "true"
  environment = "public"
  tenant_id               = "${{ secrets.azuretenant_id }}"
  subscription_id         = "${{ secrets.azuresuscription_id }}"
  client_id               = "${{ secrets.terraformclient_id }}"
  client_secret           = "${{ secrets.terraformclient_secret }}"
}

# Make client_id, tenant_id, subscription_id and object_id variables
data "azurerm_client_config" "current" {}
