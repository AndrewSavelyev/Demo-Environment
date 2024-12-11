output "public_ip_address" {
    value                   = module.ec2.public_ip
    description             = "Public EIP address of EC2 instance"
}

output "eks1_cluster_name" {
    value                   = module.eks1.cluster_demo_name
    description             = "EKS cluster data"
}

output "eks2_cluster_name" {
    value                   = module.eks2.cluster_demo_name
    description             = "EKS cluster data"
}

output "eks1-endpoint" {
    value = module.eks1.eks-endpoint
}

output "eks2-endpoint" {
    value = module.eks1.eks-endpoint
}

output "eks1-certificate" {
    value = module.eks1.kubeconfig-certificate-authority-data
}

output "eks2-certificate" {
    value = module.eks1.kubeconfig-certificate-authority-data
}