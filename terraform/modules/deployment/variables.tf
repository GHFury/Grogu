variable "name" {
  description = "Name of the deployment"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy into"
  type        = string
}

variable "image" {
  description = "Docker image to deploy"
  type        = string
}

variable "replicas" {
  description = "Number of pod replicas"
  type        = number
  default     = 2
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8080
}

variable "environment_vars" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "image_pull_policy" {
  description = "Image pull policy"
  type        = string
  default     = "IfNotPresent"
}

