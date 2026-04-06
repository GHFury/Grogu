output "service_name" {
  description = "Name of the service"
  value       = kubernetes_service.this.metadata[0].name
}

output "cluster_ip" {
  description = "ClusterIP of the service"
  value       = kubernetes_service.this.spec[0].cluster_ip
}
