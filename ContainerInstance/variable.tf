variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location for all resources."
}
variable "container_group_name" {
  type = string
  default = "first-container-group"
}
variable "container_name" {
  type = string
  default = "first-container"
}
variable "image" {
  type        = string
  description = "Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials."
  default     = "aayush0307/pythonmyapp:V.26"
}

variable "port" {
  type        = number
  description = "Port to open on the container and the public IP address."
  default     = 5000
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the container."
  default     = 1.5
}

variable "memory_in_gb" {
  type        = number
  description = "The amount of memory to allocate to the container in gigabytes."
  default     = 2
}

variable "restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped."
  default     = "Always"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}
variable "backend_address_pool_name" {
  type = string
  default = "backend-pool"
}
variable "backend_http_settings_name" {
  type = string
  default = "backendhttp"
}
variable "frontend_ip_configuration_name" {
  type = string
  default = "frontend-ip-config"
}
variable "frontend_port_name" {
  type = string
  default = "example-frontend-port"
}