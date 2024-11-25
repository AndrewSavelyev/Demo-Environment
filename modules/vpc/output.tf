output "aws_vpc_cidr_block" {
    value           = aws_vpc.main.cidr_block    
    description     = "Output of the CIDR block for VPC"

}

output "aws_vpc_id" {
    value           = aws_vpc.main.id    
    description     = "Output of the Id for VPC"
}

output "aws_igw_id" {
    value           = aws_internet_gateway.igw.id    
    description     = "VPC's gateway"
}

output "aws_route_table_public_id" {
    value           = aws_default_route_table.main.id
    description     = "Public route table's id, which is default route table"
}

