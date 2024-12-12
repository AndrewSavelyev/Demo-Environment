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
  type        = number
  description = "EKS nodes desired quontity"
}

variable "min_size" {
  type        = number
  description = "EKS nodes minimal quontity"
}