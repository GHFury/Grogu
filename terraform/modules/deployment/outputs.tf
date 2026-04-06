output "deployment_name" {
  description = "Name of the deployment"
  value       = kubernetes_deployment.this.metadata[0].name
}

output "namespace" {
  description = "Namespace the deployment is in"
  value       = kubernetes_deployment.this.metadata[0].namespace
}
