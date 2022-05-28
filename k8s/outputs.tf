// Output kubernetes resource
output "cluster_id" {
  description = "ID of the kunernetes cluster."
  value       = [alicloud_cs_managed_kubernetes.k8s.*.id]
}

output "version" {
  description = "The Kubernetes server version for the cluster."
  value       = [alicloud_cs_managed_kubernetes.k8s.*.version]
}

output "slb_intranet" {
  description = "The ID of private load balancer where the current cluster master node is located."
  value       = alicloud_cs_managed_kubernetes.k8s.*.slb_intranet
}

output "certificate_authority" {
  description = "Nested attribute containing certificate authority data for your cluster."
  value       = alicloud_cs_managed_kubernetes.k8s.*.certificate_authority
}

output "connections" {
  description = "Map of kubernetes cluster connection information."
  value       = alicloud_cs_managed_kubernetes.k8s.*.connections
}

