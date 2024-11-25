output "aws_vpc_cidr_block" {
    value                   = module.vpc.aws_vpc_cidr_block
    description             = "VPC cidr_block"
}

output "aws_instance_id" {
    value           = module.ec2.aws_instance_id
    description     = "EC2 instance id"
}

output "public_ip_address" {
    value                   = module.ec2.public_ip
    description             = "Public EIP address of EC2 instance"
}

output "eks_cluster" {
    value                   = module.eks.aws_eks_cluster_demo
    description             = "EKS cluster data"
}

output "ec2_user_data" {
    value                   = module.ec2.aws_instance_user_data
    description             = "EC2 instance user data"
}

