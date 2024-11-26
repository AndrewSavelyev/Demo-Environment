output "aws_instance_ami" {
    value = aws_instance.main.ami    
    description = "EC2 ami instance"

}

output "aws_instance_type" {
    value = aws_instance.main.instance_type    
    description = "EC2 instance type"
}

output "aws_instance_id" {
    value = aws_instance.main.id    
    description = "EC2 instance id"
}

output "ec2_private_key_name" {
  value     = aws_key_pair.main.key_name
  description = "EC2 key pair name"
}

output "public_ip" {
    value = aws_eip.main.public_ip
    description = "EC2 instance public ip address"
}

output "aws_instance_user_data" {
    value = aws_instance.main.user_data  
    description = "EC2 instance user data"
}

