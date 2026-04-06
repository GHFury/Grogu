variable "image" {
  description = "Docker image to deploy"
  type        = string
  default     = "deadpool-app:latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}
