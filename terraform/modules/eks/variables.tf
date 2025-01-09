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
<<<<<<< HEAD
  type        = number
  description = "Cluster nodes desired_size"
}

variable "min_size" {
  type        = number
  description = "Cluster nodes minimum_size"
}
=======
  type    = number
  default = 1  
  description = "EKS pods desired quontity"
}

variable "max_size" {
  type    = number
  default = 5  
  description = "EKS pods maximum quontity"
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
>>>>>>> 498bc6a9c31409c41bd5e7f42989dd73f8bda7e4
