variable "vpc_id" {
  type    = string
  default = ""  
  description = "VPC id"
}

variable "bastion_cidr_block" {
  type    = string
  default = ""  
  description = "VPC's CIDR block"
}

variable "availability_zone" {
  type    = string
  default = ""  
  description = "VPC's availability zone"
}

variable "aws_security_group" {
  type    = string
  default = ""  
  description = "Security Group's name"
}

variable "sg_cidr_block" {
  type    = string
  default = ""  
  description = "Security Group's CIDR Block"
}

variable "sg_ingress_from_port" {
  type    = string
  default = ""  
  description = "Security Group Ingress from port"
}

variable "sg_ingress_to_port" {
  type    = string
  default = ""  
  description = "Security Group Ingress to port"
}

variable "sg_ingress_protocol" {
  type    = string
  default = ""  
  description = "Security Group Ingress protocol"
}

variable "sg_egress_from_port" {
  type    = string
  default = ""  
  description = "Security Group Egress from port"
}

variable "sg_egress_to_port" {
  type    = string
  default = ""  
  description = "Security Group Egress to port"
}

variable "sg_egress_protocol" {
  type    = string
  default = ""  
  description = "Security Group Egress protocol"
}

variable "rt_cidr_block" {
  type    = string
  default = ""  
  description = "Route table CIDR block"
}

