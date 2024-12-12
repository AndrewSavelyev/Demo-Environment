variable "name" {
  type        = string
  default     = "" 
  description = "Cluster's name"
}

variable "private-ids" {
  type        = list(string)
  description = "Private subnets id's"
}

variable "public-ids" {
  type        = list(string)
  description = "Public-ids subnets id's"
}

variable "desired_size" {
  type    = number
  default = 1  
  description = "EKS pods desired quontity"
}

variable "min_size" {
  type    = number
  default = 1  
  description = "EKS pods minimal quontity"
}    

variable "vpc_id" {
  type    = string
  default = ""  
  description = "VPC id"
}
