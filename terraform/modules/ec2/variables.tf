variable "ec2_ami" {
  type        = string
  default     = "" 
  description = "EC2 ami image"
}

variable "ec2_instanse_type" {
  type        = string
  default     = "" 
  description = "EC2 instance type" 
}

variable "ec2_tag" {
  type        = string
  default     = "" 
  description = "EC2 instance tag" 
}

variable "ec2_network_interface_id" {
  type        = string
  default     = ""  
  description = "EC2 network interface id"
}

variable "aws_instance_main_subnet_id" {
  type        = string
  default     = ""  
  description = "EC2 instance main subnet id"
}

variable "ec2_private_ips" {
  type        = list
  description = "EC2 instance private ip address"
}

variable "key_name" {
  type        = string
  default     = ""   
  description = "EC2 instance key name"
}

variable "key_pair_name" {
  type        = string
  default     = ""   
  description = "EC2 instance key pair name"
}