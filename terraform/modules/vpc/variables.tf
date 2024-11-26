
variable "aws_vpc_cidr_block" {
  type        = string
  default     = "" 
  description = "CIDR block for vpc"
}


variable "private-us-east-1a_id" {
  type        = string
  default     = "" 
  description = "Private subnet's id in AZ s-east-1a"
}

variable "private-us-east-1b_id" {
  type        = string
  default     = "" 
  description = "Private subnet's id in AZ s-east-1b"
}

variable "public-us-east-1a_id" {
  type        = string
  default     = "" 
  description = "Public subnet's id in AZ s-east-1a"
}

variable "public-us-east-1b_id" {
  type        = string
  default     = "" 
  description = "Public subnet's id in AZ s-east-1b"
}

/*
variable "route_table_public_id" {
  type        = string
  default     = "" 
  description = "Public route table's id in AZ s-east-1a"
}
*/

variable "aws_instance_id" {
  type        = string
  default     = "" 
  description = "Bastion id"
}

