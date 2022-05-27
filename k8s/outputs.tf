// Output kubernetes resource
output "cluster_id" {
  description = "ID of the kunernetes cluster."
  value       = [alicloud_cs_managed_kubernetes.k8s.*.id]
}

output "slb_intranet" {
  description = "SLB"
  value       = alicloud_cs_managed_kubernetes.k8s.*.slb_intranet
}

output "certificate_authority" {
  description = "SLB"
  value       = alicloud_cs_managed_kubernetes.k8s.*.certificate_authority
}

output "connections" {
  description = "k8s connections"
  value       = alicloud_cs_managed_kubernetes.k8s.*.connections
}
