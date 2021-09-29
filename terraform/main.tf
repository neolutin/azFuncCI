module "api" {
  source = "./function-ase"
  resource_group_name = var.resource_group_name
  app_service_plan_name = var.app_service_plan_name
  storage_account_name = var.storage_account_name
  function_app_name = var.function_app_name
  location = var.location
  tags = var.tags
}

module "function" {
  source = "./function-ase"
  resource_group_name = var.resource_group_name
  app_service_plan_name = var.app_service_plan_name
  storage_account_name = var.storage_account_name
  function_app_name = var.function_app_name
  dataapi_url = var.dataapi_url
  location = var.location
  tags = var.tags
}
