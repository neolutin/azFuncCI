variable "resource_group_name" {
  description = "The name of the resource group in which the function app will be created."
  type        = string
}

variable "location" {
  description = "Location of the ressources."
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the app service plan in which the function app will be created."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account for state management."
  type        = string
}

variable "api_name" {
  description = "The name of the function to create."
  type        = string
}

variable "function_app_name" {
  description = "The name of the function to create."
  type        = string
}

variable "dataapi_url" {
  description = "Data API Url"
  type        = string
}

variable "tags" {
    type = map
    default = {
      "Terraform" = "true"
      "environment" = "test"
    }
    description = "Azure Resource Tags"
}
