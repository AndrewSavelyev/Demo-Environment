output "public_ip_address" {
    value                   = module.ec2.public_ip
    description             = "Public EIP address of EC2 instance"
}

output "eks1_cluster_name" {
    value                   = module.eks1.cluster_demo_name
    description             = "EKS cluster data"
}
/*
output "eks2_cluster_name" {
    value                   = module.eks2.cluster_demo_name
    description             = "EKS cluster data"
}
*/