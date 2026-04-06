output "namespace" {
  description = "Deployed namespace"
  value       = module.namespace.name
}

output "deployment" {
  description = "Deployment name"
  value       = module.deployment.deployment_name
}

output "service" {
  description = "Service name"
  value       = module.service.service_name
}
