variable "image" {
  description = "Docker image to deploy"
  type        = string
  default     = "nginx:latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}
