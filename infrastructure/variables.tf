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
  type = string
  default = "container-app-playground"
}

variable "my_little_secret" {
  type = string
  default = "Super secret value!"
}

variable "open_config" {
  type = string
  default = "Open value"
}

variable "image" {
  type = string
}