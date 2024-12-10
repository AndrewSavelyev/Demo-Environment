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