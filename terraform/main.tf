resource "aws_security_group" "eks_cluster_security_group" {
  name        = "eks-cluster-sg"
  description = "EKS Cluster security group"
  vpc_id      = "vpc-020ac24c7a332a6fa"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eks_cluster" "go_tick_tock_bong_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = [
      "subnet-04da2eeeb4d39e59b",
      "subnet-0bccc63198fc6a217",
      "subnet-09e70631f6a4e6744"
    ]
    security_group_ids = ["sg-0baa4b22652b86e4d"]  # Usar el grupo de seguridad existente
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "go_tick_tock_bong_cluster_role"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_eks_node_group" "go_tick_tock_bong_node_group" {
  cluster_name    = aws_eks_cluster.go_tick_tock_bong_cluster.name
  node_group_name = "go-tick-tock-bong-node-group"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = [
    "subnet-04da2eeeb4d39e59b",
    "subnet-0bccc63198fc6a217",
    "subnet-09e70631f6a4e6744"
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

resource "aws_iam_role" "node_group_role" {
  name = "go_tick_tock_bong_node_group_role"

  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role_policy.json
}

data "aws_iam_policy_document" "node_group_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_availability_zones" "available" {
  state = "available"
}