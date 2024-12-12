# IAM role with the AmazonEKSClusterPolicy
# First- we provides an IAM role
resource "aws_iam_role" "demo" {
  name = "${var.name}-cluster_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    tag-key = "EKS claster demo access"
  }
}

# Second- we attaches a Managed IAM Policy to an IAM role
resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}

# And now- we creating the EKS cluster itself
resource "aws_eks_cluster" "demo" {
  name     = "${var.name}-cluster"
  role_arn = aws_iam_role.demo.arn
  vpc_config {  
    security_group_ids      = [aws_security_group.demo.id]
    endpoint_private_access = true
    endpoint_public_access  = true    
    subnet_ids              = concat(var.private-ids,var.public-ids)
  }
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}

# Next, we are going to create IAM role for a single instance group for Kubernetes
resource "aws_iam_role" "nodes" {
  name               = "${var.name}-nodes-group-role"
  assume_role_policy = jsonencode({
    Statement        = [{
      Action         = "sts:AssumeRole"
      Effect         = "Allow"
      Principal      = {
        Service      = "ec2.amazonaws.com"
      }
    }]
    Version          = "2012-10-17"
  })
}

# And then- we attache a Managed IAM Policy to an IAM role
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy" "nodes-ClusterAutoscalerPolicy" {
  name = "${var.name}-auto-scaler"
  role = aws_iam_role.nodes.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeTags",
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#######################################################################################################
# Our cluster has two node groups. One for internal workloads and one for Internet facing workloads. ##
#
#  Internal workloads will reside on a private node group deployed on private subnets.
#
# Internet facing workloads will reside on a public node group deployed on public subnets.
#######################################################################################################
# Now are creating private nodes group for EKS
resource "aws_eks_node_group" "private-nodes" {
  cluster_name      = aws_eks_cluster.demo.name
  node_group_name   = "${var.name}-private-nodes"
  node_role_arn     = aws_iam_role.nodes.arn
  subnet_ids        = var.private-ids
  capacity_type     = "ON_DEMAND"
  instance_types    = ["t3.small"]

  scaling_config {
    desired_size    = var.desired_size
    max_size        = 5
    min_size        = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels            = {
    "type"          = "private"
  }

  depends_on        = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Now are creating public nodes group for EKS

resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "${var.name}-public-nodes"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.public-ids
  capacity_type     = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size    = var.desired_size
    max_size        = 5
    min_size        = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels          = {
    "type" = "public"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}
##########################################################################################################################################
# Now we are creating OpenID connect provider, which will allow granting IAM permissions based on the service account used by the pod   ##
# We use this data source to get information, such as SHA1 fingerprint or serial number, about the TLS certificates that protects a URL ##
##########################################################################################################################################
data "tls_certificate" "eks" {
  url = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}

#####################################################################
# Cluster Security Groups                                          ##
#####################################################################

resource "aws_security_group" "demo" {
  name        = "${var.name}-cluster/ControlPlaneSecurityGroup"
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-cluster/ControlPlaneSecurityGroup"    
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow unmanaged nodes to communicate with control plane (all ports)"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_eks_cluster.demo.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.demo_nodes.id
  to_port                  = 0
  type                     = "ingress"
}

# Node Security Groups

resource "aws_security_group" "demo_nodes" {
  name        = "${var.name}-cluster/ClusterSharedNodeSecurityGroup"
  description = "Communication between all nodes in the cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_eks_cluster.demo.vpc_config[0].cluster_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-cluster/ClusterSharedNodeSecurityGroup"
  }
}