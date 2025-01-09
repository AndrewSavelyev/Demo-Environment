output "public_ip_address" {
    value                   = module.ec2.public_ip
    description             = "Public EIP address of EC2 instance"
}

output "eks1_cluster_name" {
    value                   = module.eks1.cluster_demo_name
    description             = "EKS cluster data"
}
<<<<<<< HEAD
/*
output "eks2_cluster_name" {
    value                   = module.eks2.cluster_demo_name
    description             = "EKS cluster data"
}
*/
=======

>>>>>>> 498bc6a9c31409c41bd5e7f42989dd73f8bda7e4
