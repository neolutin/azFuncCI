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

variable "app_name" {
  description = "The name of the web app to create."
  type        = string
}
