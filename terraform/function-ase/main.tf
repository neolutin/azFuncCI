# Make client_id, tenant_id, subscription_id and object_id variables
data "azurerm_client_config" "current" {}


# Resource Group
resource "azurerm_resource_group" "fnapp" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Storage
resource "azurerm_storage_account" "fnapp" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.fnapp.name
  location                 = azurerm_resource_group.fnapp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Functions App Service Plan
resource "azurerm_app_service_plan" "fnapp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.fnapp.name
  location            = azurerm_resource_group.fnapp.location
  kind                = "Linux"
  reserved            = true
  
  sku {
    tier = "Free"
    size = "F1"
  }
}

# Storage Container
resource "azurerm_storage_container" "fnapp" {
  container_access_type = "private"
  name                  = var.function_app_name
  storage_account_name  = azurerm_storage_account.fnapp.name
}

# FunctionApp
resource "azurerm_function_app" "fnapp" {
  name = var.function_app_name
  tags = var.tags
  app_settings = {
    # Runtime configuration
    FUNCTIONS_WORKER_RUNTIME        = "dotnet"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE = "true" 
    WEBSITE_RUN_FROM_PACKAGE        = "1"
    # APPINSIGHTS_INSTRUMENTATIONKEY  = azurerm_application_insights.application_insights.instrumentation_key
    # Azure Functions configuration
    DataApiUrl                      = var.dataapi_url
  }
  
  identity {
    type = "SystemAssigned"
  }
  app_service_plan_id        = azurerm_app_service_plan.fnapp.id
  location                   = azurerm_resource_group.fnapp.location
  resource_group_name        = azurerm_resource_group.fnapp.name
  storage_account_name       = azurerm_storage_account.fnapp.name
  storage_account_access_key = azurerm_storage_account.fnapp.primary_access_key
  # dotnet core version (app_settings.FUNCTIONS_EXTENSION_VERSION never set/updated)
  https_only                 = true
}
