variable "location" {
  default = "eastus"
}

variable "rg_name" {
  default = "container-apps-playground-eus"
}

variable "acr_name" {
  default = "pmacreus"
}

variable "acr_create" {
  type    = bool
  default = false
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

variable "cosmos_create" {
  type    = bool
  default = false
}

variable "vnet_name" {
  default = "container-app-playground-vnet"
}

variable "vnet_create" {
  type       = bool
  default = false
}

variable "my_little_secret" {
  default = "Super secret value!"
}

variable "open_config" {
  default = "Open value"
}

variable "app_port" {
  default = 80
  type    = number
}

variable "app_custom_domain" {
  default = "container-app-playground.chickenkiller.com"
}

variable "app_tls_cert_file" {
  default = "./certs/container-app-playground.chickenkiller.com/cert.pem"
}

variable "app_tls_cert_pass_file" {
  default = "./certs/container-app-playground.chickenkiller.com/certpass"
}

variable "image" {
  // placeholder: mcr.microsoft.com/azuredocs/containerapps-helloworld:latest
  type    = string
  default = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}
