variable "location" {
  default = "eastus"
}

variable "rg_name" {
  default = "container-apps-playground-eus"
}

variable "acr_name" {
  default = "pmacreus"
}

variable "identity_name" {
  default = "pmacreuspull"
}

variable "law_name" {
  default = "pmlaweus"
}

variable "env_name" {
  default = "container-apps-playground-env"
}

variable "app_name" {
  default = "container-app-playground"
}

variable "cosmos_name" {
  default = "container-app-playground-cosmosdb"
}

variable "my_little_secret" {
  default = "Super secret value!"
}

variable "open_config" {
  default = "Open value"
}

variable "app_port" {
  default = 3000
  type    = number
}

variable "image" {
  // placeholder: mcr.microsoft.com/azuredocs/containerapps-helloworld:latest
  type    = string
  default = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
