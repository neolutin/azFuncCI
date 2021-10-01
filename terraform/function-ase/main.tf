# Make client_id, tenant_id, subscription_id and object_id variables
data "azurerm_client_config" "current" {}

# Functions App Service Plan
resource "azurerm_app_service_plan" "fnapp" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "functionapp"
  reserved            = true
  is_xenon            = false
  
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# FunctionApp
resource "azurerm_function_app" "fnapp" {
  name = var.function_app_name
  app_settings = {
    # Runtime configuration
    FUNCTIONS_WORKER_RUNTIME        = "dotnet"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE = "true" 
    WEBSITE_RUN_FROM_PACKAGE        = "1"
    # APPINSIGHTS_INSTRUMENTATIONKEY  = azurerm_application_insights.application_insights.instrumentation_key
    # Azure Functions configuration
    DataApiUrl                      = var.dataapi_url
  }

  site_config {
    use_32_bit_worker_process = true
  }

  identity {
    type = "SystemAssigned"
  }
  app_service_plan_id        = azurerm_app_service_plan.fnapp.id
  location                   = var.location
  resource_group_name        = var.resource_group_name
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.primary_access_key
  # dotnet core version (app_settings.FUNCTIONS_EXTENSION_VERSION never set/updated)
  https_only                 = true
  client_cert_mode           = "Optional"
  daily_memory_time_quota    = 0
  os_type                    = "linux"
  tags                       = var.tags
}
