variable "name" {
  description = "Name of the service"
  type        = string
}

variable "namespace" {
  description = "Namespace the service lives in"
  type        = string
}

variable "port" {
  description = "Port the service exposes"
  type        = number
  default     = 8080
}

variable "target_port" {
  description = "Port on the container to forward to"
  type        = number
  default     = 8080
}
