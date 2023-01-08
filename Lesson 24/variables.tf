// Declaring variables
variable "zone" {
  type = string
}

variable "cloudName" {
  description = "Please enter your cloud ID"
  type        = string
}


variable "lamp-version" {
  description = "LAMP version:"
  type        = string
}

variable "allowed_zones" {
  description = "Zones where instances would be placed"
  type        = list(any)
}

variable "is-preemptible" {
  description = "Make preemptible VMs? Input true or false"
  type        = bool
}

variable "my-labels" {
  description = "Please input your own labels (MAP)"
  type        = map(any)
}

variable "platformVersion" {
  description = "Please input platform ID"
  type        = string
}

variable "isTest" {
  description = "Is it a test TF?"
  type        = bool
  default     = false
}

variable "os" {
  description = "OS Family"
  type = string
  default = "debian"
}

variable "instance-type" {
  default = {
    "dev" = "standard-v1"
    "staging" = "standard-v2"
    "prod" = "standard-v3"
  }
}
