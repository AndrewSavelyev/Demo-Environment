variable "vpc_id" {
  type    = string
  default = ""  
  description = "VPC id"
}

variable "availability_zones" {
  type    = list(string)
  description = "Network's availability zone"
}

variable "default_route_table_id" {
  type    = string
  default = ""  
  description = "VPC's defaultroute table id"
}

variable "vpc_cidr" {
  type    = string
  default = ""  
  description = "VPC cidr"
}

variable "private_cidrs" {
  type    = list(string)
  description = "Private networks cidr"
}

variable "public_cidrs" {
  type    = list(string)
  description = "Public networks cidr"
}


  
  
  
  