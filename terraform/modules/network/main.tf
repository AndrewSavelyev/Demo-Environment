# VPC Subnet for Bastion
resource "aws_subnet" "main" {
  vpc_id            = var.vpc_id
  cidr_block        = var.bastion_cidr_block
    
  tags          = {
    Name        = "Main"
  }
}

# Security Group parameters
resource "aws_default_security_group" "main" {
   vpc_id           = aws_subnet.main.vpc_id
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags              = {
    Name            = "allow_ssh"
  }
}

########################################################
# Setup EKS environment
########################################################

# To meet Amazon EKS networking requirements we need to create at least two subnets that are in different Availability Zones
# First private subnet
resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    "Name"                            = "private-us-east-1a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

# Second private subnet
resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    "Name"                            = "private-us-east-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

# First pulic subnet (for load balancer)
resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-us-east-1a"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

# Second pulic subnet (for load balancer)
resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-us-east-1b"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

#####################################################################
# Security Groups for clusters's subnets                           ##
#####################################################################
# First subnet private-us-east-1a

resource "aws_security_group" "allow_pf_private-us-east-1a" {
  name        = "allow_port_forwarding_for_private-us-east-1a"
  description = "Allow port forwarding inside and outside containers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_port_forwarding"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pf_private-us-east-1a" {
  security_group_id = aws_security_group.allow_pf_private-us-east-1a.id
  cidr_ipv4         = aws_subnet.private-us-east-1a.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_pf_private-us-east-1a" {
  security_group_id = aws_security_group.allow_pf_private-us-east-1a.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Second subnet private-us-east-1b

resource "aws_security_group" "private-us-east-1b" {
  name        = "allow_port_forwarding_private-us-east-1b"
  description = "Allow port forwarding inside and outside containers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_port_forwarding"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pf_private-us-east-1b" {
  security_group_id = aws_security_group.private-us-east-1b.id
  cidr_ipv4         = aws_subnet.private-us-east-1b.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_pf_private-us-east-1b" {
  security_group_id = aws_security_group.private-us-east-1b.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

###############################################################################
# First subnet public-us-east-1a

resource "aws_security_group" "allow_pf_public-us-east-1a" {
  name        = "allow_port_forwarding_for_public-us-east-1a"
  description = "Allow port forwarding inside and outside containers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_port_forwarding"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pf_public-us-east-1a" {
  security_group_id = aws_security_group.allow_pf_public-us-east-1a.id
  cidr_ipv4         = aws_subnet.public-us-east-1a.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_pf_public-us-east-1a" {
  security_group_id = aws_security_group.allow_pf_public-us-east-1a.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Second subnet private-us-east-1b

resource "aws_security_group" "public-us-east-1b" {
  name        = "allow_port_forwarding_public-us-east-1b"
  description = "Allow port forwarding inside and outside containers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_port_forwarding"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pf_public-us-east-1b" {
  security_group_id = aws_security_group.public-us-east-1b.id
  cidr_ipv4         = aws_subnet.public-us-east-1b.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_pf_public-us-east-1b" {
  security_group_id = aws_security_group.public-us-east-1b.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}