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
  description = "The name of the storage accoun for state management."
  type        = string
}

variable "function_app_name" {
  description = "The name of the function to create."
  type        = string
}

variable "dataapi_url" {
  description = "Data API Url"
  type        = string
  default     = ""
}

variable "tags" {
    type = map
    default = {
      "Terraform" = "true"
    }
    description = "Azure Resource Tags"
}

variable "primary_access_key" {
    type = string
    description = "azurerm_storage_account access key"
}
