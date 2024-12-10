
output "private_ids" {  
    value       = aws_subnet.private[*].id
    description = "Private subnets"
}

output "public_ids" {
    value       = aws_subnet.public[*].id
    description = "Public subnets"
}
