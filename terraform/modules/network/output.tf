output "aws_subnet" {
    value = aws_subnet.main.cidr_block
    description = "Subnet CIDR block"
}

output "aws_subnet_main_id" {
    value = aws_subnet.main.id
    description = "VPC subnet id"
}

output "private-us-east-1a_id" {
    value = aws_subnet.private-us-east-1a.id
    description = "Private subnet in AZ us-east-1a"
}

output "private-us-east-1b_id" {
    value = aws_subnet.private-us-east-1b.id
    description = "Private subnet in AZ us-east-1b"
}

output "public-us-east-1a_id" {
    value = aws_subnet.public-us-east-1a.id
    description = "Public subnet in AZ us-east-1a"
}


output "public-us-east-1b_id" {
    value = aws_subnet.public-us-east-1b.id
    description = "Public subnet in AZ us-east-1b"
}