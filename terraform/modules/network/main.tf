
# To meet Amazon EKS networking requirements we need to create at least two subnets that are in different Availability Zones
# Private subnets
resource "aws_subnet" "private" {
  count                               = length(var.availability_zones)
  vpc_id                              = var.vpc_id
  cidr_block                          = element(var.private_cidrs, count.index)  
  availability_zone                   = element(var.availability_zones, count.index)
  map_public_ip_on_launch             = false
  tags                                = {
    "Name"                            = "private-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

# Public subnets (for Bastion and Load balancer)
resource "aws_subnet" "public" {
  count                          = length(var.availability_zones)
  vpc_id                         = var.vpc_id  
  cidr_block                     = element(var.public_cidrs, count.index)  
  availability_zone              = element(var.availability_zones, count.index)
  map_public_ip_on_launch        = true
  tags                           = {
    "Name"                       = "public-${count.index}"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

# Internet gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id         = var.vpc_id
}

resource "aws_route_table" "public" {
  vpc_id         = var.vpc_id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id    
  }  
  tags           = {
    Name         = "public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# EIP for NAT gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags          = {
    Name        = "nat"
  }
}

resource "aws_default_route_table" "private" {
  default_route_table_id = var.default_route_table_id
  route {
    cidr_block           = "0.0.0.0/0"
    gateway_id           = aws_nat_gateway.nat.id
  }
  tags                   = {
    Name                 = "private"
  }
}

# Association of Route table's with subnet's
resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_default_route_table.private.id
}

# Security Group parameters
resource "aws_default_security_group" "allow_ssh" {
   vpc_id           = var.vpc_id
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags              = {
    Name            = "allow_ssh"
  }
}
#####################################################################
# Security Groups for clusters's subnets                           ##
#####################################################################
# Private subnets

resource "aws_security_group" "allow_pf_private-subnets" {
  name        = "allow_port_forwarding_for_private-subnets"
  description = "Allow port forwarding inside and outside containers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_port_forwarding"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pf_private-subnets" {
  count             = length(var.availability_zones)
  security_group_id = aws_security_group.allow_pf_private-subnets.id
  cidr_ipv4         = element(var.private_cidrs, count.index)
  from_port         = 31000
  ip_protocol       = "tcp"
  to_port           = 31000
}

resource "aws_vpc_security_group_egress_rule" "allow_pf_private-subnets" {
  security_group_id = aws_security_group.allow_pf_private-subnets.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

###############################################################################
# Public subnets

resource "aws_security_group" "allow_pf_public-subnets" {
  name        = "allow_port_forwarding_for_public-subnets"
  description = "Allow port forwarding inside and outside containers"
  vpc_id      = var.vpc_id
  tags        = {
    Name      = "allow_port_forwarding"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pf_public-subnets" {
  count             = length(var.availability_zones)
  security_group_id = aws_security_group.allow_pf_public-subnets.id
  cidr_ipv4         = element(var.public_cidrs, count.index)
  from_port         = 31000
  ip_protocol       = "tcp"
  to_port           = 31000
}

resource "aws_vpc_security_group_egress_rule" "allow_pf_public-subnets" {
  security_group_id = aws_security_group.allow_pf_public-subnets.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

