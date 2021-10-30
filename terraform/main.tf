# Resource Group
resource "azurerm_resource_group" "azfuncci" {
  name     = var.resource_group_name
  location = "westeurope"
  tags     = var.tags
}

resource "azurerm_policy_definition" "azfuncci_policy" {
  name         = "only-deploy-in-westeurope"
  display_name = "Only Deploy In Westeurope"
  policy_type  = "Custom"
  mode         = "All"

  policy_rule  = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "equals": "westeurope"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE
}

resource "azurerm_resource_group_policy_assignment" "azfuncci_policy_assignment" {
  name                 = "azfuncci_policy_assignment"
  resource_group_id    = azurerm_resource_group.azfuncci.id
  policy_definition_id = azurerm_policy_definition.azfuncci_policy.id
}

# Storage
resource "azurerm_storage_account" "azfuncci" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.azfuncci.name
  location                 = azurerm_resource_group.azfuncci.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Storage Container
resource "azurerm_storage_container" "azfuncci" {
  container_access_type = "private"
  name                  = var.function_app_name
  storage_account_name  = azurerm_storage_account.azfuncci.name
}

module "api" {
  source = "./app-service"
  resource_group_name = azurerm_resource_group.azfuncci.name
  location = azurerm_resource_group.azfuncci.location
  app_service_plan_name = var.api_service_plan_name
  app_name = var.api_name
}

module "function" {
  source = "./function-ase"
  resource_group_name = azurerm_resource_group.azfuncci.name
  app_service_plan_name = var.app_service_plan_name
  storage_account_name = azurerm_storage_account.azfuncci.name
  function_app_name = var.function_app_name
  dataapi_url = var.dataapi_url
  location = azurerm_resource_group.azfuncci.location
  primary_access_key =  azurerm_storage_account.azfuncci.primary_access_key
  tags = var.tags
}
