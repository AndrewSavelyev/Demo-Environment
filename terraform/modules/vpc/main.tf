# Module VPC
resource "aws_vpc" "main" {
  cidr_block            = var.aws_vpc_cidr_block
  instance_tenancy      = "default"

  tags                  = {
    Name                = "demo VPC"
  }  
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id           = aws_vpc.main.id
}

# Public Route table
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block           = "0.0.0.0/0"
    gateway_id           = aws_internet_gateway.igw.id
  }
  
  tags             = {
    Name           = "Main route table"
  }
}

########################################################
# Setup EKS environment
########################################################

# EIP for NAT gateway
resource "aws_eip" "nat" {
  domain                 = "vpc"

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public-us-east-1a_id
#  connectivity_type = "private"

  tags = {
    Name = "nat"
  }
}

# Route table for private subnet in AZ 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
      cidr_block             = "0.0.0.0/0"
      gateway_id             = aws_nat_gateway.nat.id
      
    }  

  tags = {
    Name = "private"
  }
}

# !!!!!!!!!!Public route table alreay exist in the Module VPC


# Association of Route table's with subnet's
resource "aws_route_table_association" "private-us-east-1a" {
  subnet_id      = var.private-us-east-1a_id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id      = var.private-us-east-1b_id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = var.public-us-east-1a_id
  route_table_id = aws_default_route_table.main.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id      = var.public-us-east-1b_id
  route_table_id = aws_default_route_table.main.id
}

