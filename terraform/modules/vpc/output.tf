output "vpc_cidr" {
    value           = aws_vpc.main.cidr_block    
    description     = "Output of the CIDR block for VPC"
}

output "aws_vpc_id" {
    value           = aws_vpc.main.id    
    description     = "Output of the Id for VPC"
}

output "default_route_table_id" {
    value           = aws_vpc.main.default_route_table_id    
    description     = "VPC's default route table id"
}
