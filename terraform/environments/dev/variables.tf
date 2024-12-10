variable "ec2_ami" {
  type            = string
  default         = "ami-0866a3c8686eaeeba"   
  description     = "EC2 ami's image"
}

variable "ec2_instanse_type" {
  type        = string
  default     = "t2.micro"
  description = "Type of EC2 instance"
}

variable "aws_security_group" {
  type        = string
  default     = "sg" 
  description = "Security Group for VPC"
}





