output "cluster_demo_name" {
  value       = aws_eks_cluster.demo.name
  description = "EKS info"
}

output "eks-endpoint" {
    value = aws_eks_cluster.demo.endpoint
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.demo.certificate_authority[0].data
}

