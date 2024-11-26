# Module VPC parameters definition
module "vpc" {  
  source                          = "../../modules/vpc"
  aws_vpc_cidr_block              = var.aws_vpc_cidr_block
  aws_instance_id                 = module.ec2.aws_instance_id
  private-us-east-1a_id           = module.network.private-us-east-1a_id
  private-us-east-1b_id           = module.network.private-us-east-1b_id
  public-us-east-1a_id            = module.network.public-us-east-1a_id
  public-us-east-1b_id            = module.network.public-us-east-1b_id 
}

# Module Network parameters definition
module "network" { 
  source = "../../modules/network"
  bastion_cidr_block              = "10.0.10.0/24"
#  cidr_block              = module.vpc.aws_vpc_cidr_block
  vpc_id                  = module.vpc.aws_vpc_id
  availability_zone       = var.region
  aws_security_group      = var.aws_security_group  
}

# Module EC2
module "ec2" {
  source = "../../modules/ec2"
  ec2_ami = var.ec2_ami
  ec2_instanse_type           = var.ec2_instanse_type
  ec2_tag                     = var.ec2_tag
  key_name                    = module.ec2.ec2_private_key_name
  key_pair_name               = "asavelyev"
  ec2_private_ips             = ["10.0.10.10"]
  aws_instance_main_subnet_id = module.network.aws_subnet_main_id  
}

# Module EKS
module "eks" {
  source = "../../modules/eks"
  private-us-east-1a_id           = module.network.private-us-east-1a_id
  private-us-east-1b_id           = module.network.private-us-east-1b_id
  public-us-east-1a_id            = module.network.public-us-east-1a_id
  public-us-east-1b_id            = module.network.public-us-east-1b_id
}
