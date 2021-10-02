# Make client_id, tenant_id, subscription_id and object_id variables
data "azurerm_client_config" "current" {}

# Functions App Service Plan
resource "azurerm_app_service_plan" "apiservice" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "Linux"
  reserved            = true
  
  sku {
    tier = "Free"
    size = "F1"
  }
}


resource "azurerm_app_service" "api" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.apiservice.id

  site_config {
    dotnet_framework_version  = "v5.0"
    use_32_bit_worker_process = true
    min_tls_version           = 1.2
  }
}
