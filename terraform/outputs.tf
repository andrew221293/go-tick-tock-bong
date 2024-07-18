output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.go_tick_tock_bong_cluster.endpoint
}
