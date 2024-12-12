# Module VPC parameters definition
module "vpc" {  
  source = "../../modules/vpc"
  vpc_cidr              = "10.0.0.0/16"    
}

# Module Network parameters definition
module "network" { 
  source = "../../modules/network"
  private_cidrs        = [
                         "10.0.1.0/24",
                         "10.0.2.0/24",
                         "10.0.3.0/24",
                         "10.0.4.0/24",
                         "10.0.0.0/24"
                         ]
  public_cidrs         = [
                          "10.0.5.0/24",
                          "10.0.6.0/24",
                          "10.0.7.0/24",
                          "10.0.8.0/24",
                          "10.0.9.0/24"
                        ]
  availability_zones  = [
                         "us-east-1a", 
                         "us-east-1b", 
                         "us-east-1c", 
                         "us-east-1d", 
                         "us-east-1e"
                         ]    

  vpc_id                 = module.vpc.aws_vpc_id
  vpc_cidr               = module.vpc.vpc_cidr
  default_route_table_id = module.vpc.default_route_table_id
}

# Module EC2
module "ec2" {
  source = "../../modules/ec2"
  ec2_ami                     = var.ec2_ami
  ec2_instanse_type           = var.ec2_instanse_type
  ec2_tag                     = "Bastion"
  key_pair_name               = "asavelyev"
  ec2_private_ips             = ["10.0.9.10"]
  aws_instance_main_subnet_id = module.network.public_ids[4]
}

# Module EKS1
module "eks1" {
  source = "../../modules/eks"
    
  private-ids                    = [
                                     module.network.private_ids[0], 
                                     module.network.private_ids[1]                                     
                                   ]
  public-ids                     = [
                                     module.network.public_ids[0], 
                                     module.network.public_ids[1]
                                   ]
<<<<<<< HEAD
  vpc_id                         = module.vpc.aws_vpc_id                                   
  name = "eks1"
  desired_size                   = 1    
  min_size                       = 1
                                       
=======
  desired_size                   = 1
  min_size                       = 1
  name = "eks1"                                     
>>>>>>> temp
}
# Module EKS2
module "eks2" {
  source = "../../modules/eks"
    
  private-ids                    = [
                                     module.network.private_ids[2], 
                                     module.network.private_ids[3]
                                   ]
  public-ids                     = [                                     
                                     module.network.public_ids[2], 
                                     module.network.public_ids[3]
                                   ]
<<<<<<< HEAD
  vpc_id                         = module.vpc.aws_vpc_id
  name = "eks2"
  desired_size                   = 2    
  min_size                       = 1                  
=======
  desired_size                   = 2
  min_size                       = 1
  name = "eks2"                                     
>>>>>>> temp
}
