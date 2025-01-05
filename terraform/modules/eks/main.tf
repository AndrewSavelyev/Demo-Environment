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
/*
# And now- we creating the EKS cluster itself
resource "aws_eks_cluster" "demo" {
  name     = "${var.name}"
  role_arn = aws_iam_role.demo.arn
  vpc_config {
    subnet_ids = concat(var.private-ids,var.public-ids)    
  }
  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}
*/
#################################################################################################################
# And now- we creating the EKS cluster itself                                                                   #
#################################################################################################################
resource "aws_eks_cluster" "demo" {
  name     = "${var.name}"
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
  role_arn = aws_iam_role.demo.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = concat(var.private-ids,var.public-ids)    
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}
#################################################################################################################
# Next, we are going to create IAM role for a single instance group for Kubernetes                              #
#################################################################################################################
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

# Now are creating single instance group for EKS
resource "aws_eks_node_group" "private-nodes" {
  cluster_name      = aws_eks_cluster.demo.name
  node_group_name   = "${var.name}-private-nodes"
  node_role_arn     = aws_iam_role.nodes.arn
  subnet_ids = var.private-ids
  capacity_type     = "ON_DEMAND"
  instance_types    = ["t3.medium"]
  scaling_config {
    desired_size    = var.desired_size
    max_size        = 5
    min_size        = var.min_size
  }
  update_config {
    max_unavailable = 1
  }
  labels            = {
    role            = "general"
  }
  depends_on        = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Now we are creating OpenID connect provider, which will allow granting IAM permissions based on the service account used by the pod
# We use this data source to get information, such as SHA1 fingerprint or serial number, about the TLS certificates that protects a URL
data "tls_certificate" "eks" {
  url = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}

##########################################################################################################
# Creating ecr_repository                                                                                #
##########################################################################################################

resource "aws_ecr_repository" "dockerfile" {
  name                 = "dockerfile"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "helm" {
  name                 = "helm"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}