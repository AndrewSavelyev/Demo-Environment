# Network interface for EC2
resource "aws_network_interface" "main" {
  subnet_id   = var.aws_instance_main_subnet_id
  private_ips = var.ec2_private_ips
  
  tags        = {
    Name      = "primary_network_interface"
  }
}

# Instance key
resource "tls_private_key" "main" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

# EC2 instance key pair
resource "aws_key_pair" "main" {
  key_name    = var.key_pair_name
  public_key  = tls_private_key.main.public_key_openssh
}

# EC2 instance private key pair file
resource "local_file" "foo" {
  content         = tls_private_key.main.private_key_pem
  filename        = "./private_ssh_key"
  file_permission = "600"
}

# EC2 instance
resource "aws_instance" "main" {
    ami                    = var.ec2_ami
    instance_type          = var.ec2_instanse_type
    key_name               = aws_key_pair.main.key_name
    user_data              = file("scripts/initial_config.sh")    
    network_interface {
      network_interface_id = aws_network_interface.main.id
      device_index         = 0
    }
    tags = {
      Name                 = var.ec2_tag        
    }
}

data "aws_instance" "main" {
  instance_id = aws_instance.main.id
  get_user_data = true
}

# EIP address
resource "aws_eip" "main" {
  instance                 = aws_instance.main.id
  domain                   = "vpc"
}