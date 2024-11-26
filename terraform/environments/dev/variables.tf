variable "region" {
  type            = string
  default         = "us-east-1"  
  description     = "AWS region for environment"
}

variable "aws_vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16" 
  description = "CIDR block for vpc"
}

variable "ec2_ami" {
  type            = string
#  default         = "ami-866a3c8686eaeeba" 
#  default         = "ami-005fc0f236362e99f"
   default         = "ami-0cde6390e61a03eee"   
  description     = "EC2 ami's image"
}

variable "ec2_instanse_type" {
  type        = string
  default     = "t2.micro" 
  description = "Type of EC2 instance"
}

variable "ec2_tag" {
  type            = string
  default         = "Bastion" 
  description     = "EC2 instance's tag"
}

variable "aws_security_group" {
  type        = string
  default     = "sg" 
  description = "Security Group for VPC"
}





