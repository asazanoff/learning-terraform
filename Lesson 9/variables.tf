// Declaring variables
variable "zone" {
  type = string
}

variable "cloudName" {
  description = "Please enter your cloud ID"
  type        = string
}

variable "ubuntu-version" {
  description = "Ubuntu family:"
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
