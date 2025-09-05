resource "aws_eks_cluster" "eks_a" {
  name     = "${var.project_name}-eks-a"
  role_arn = aws_iam_role.eks_cluster_role_a.arn

  vpc_config {
    subnet_ids = [aws_subnet.private_a.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_a]
}

resource "aws_eks_node_group" "nodes_a" {
  cluster_name    = aws_eks_cluster.eks_a.name
  node_group_name = "${var.project_name}-eks-nodes-a"
  node_role_arn   = aws_iam_role.eks_node_role_a.arn
  subnet_ids      = [aws_subnet.private_a.id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = [var.eks_node_instance_type]

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy_a,
    aws_iam_role_policy_attachment.eks_cni_policy_a,
    aws_iam_role_policy_attachment.eks_registry_policy_a
  ]
}

# IAM Roles for Cluster A
resource "aws_iam_role" "eks_cluster_role_a" {
  name = "${var.project_name}-eks-cluster-role-a"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_a" {
  role       = aws_iam_role.eks_cluster_role_a.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role_a" {
  name = "${var.project_name}-eks-node-role-a"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_a" {
  role       = aws_iam_role.eks_node_role_a.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_a" {
  role       = aws_iam_role.eks_node_role_a.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy_a" {
  role       = aws_iam_role.eks_node_role_a.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_security_group" "eks_nodes_a" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-eks-nodes-a-sg"
  }
}




resource "aws_eks_cluster" "eks_b" {
  name     = "${var.project_name}-eks-b"
  role_arn = aws_iam_role.eks_cluster_role_b.arn

  vpc_config {
    subnet_ids = [aws_subnet.private_b.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_b]
}

resource "aws_eks_node_group" "nodes_b" {
  cluster_name    = aws_eks_cluster.eks_b.name
  node_group_name = "${var.project_name}-eks-nodes-b"
  node_role_arn   = aws_iam_role.eks_node_role_b.arn
  subnet_ids      = [aws_subnet.private_b.id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = [var.eks_node_instance_type]

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy_b,
    aws_iam_role_policy_attachment.eks_cni_policy_b,
    aws_iam_role_policy_attachment.eks_registry_policy_b
  ]
}

# IAM Roles for Cluster B
resource "aws_iam_role" "eks_cluster_role_b" {
  name = "${var.project_name}-eks-cluster-role-b"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_b" {
  role       = aws_iam_role.eks_cluster_role_b.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role_b" {
  name = "${var.project_name}-eks-node-role-b"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_b" {
  role       = aws_iam_role.eks_node_role_b.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_b" {
  role       = aws_iam_role.eks_node_role_b.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy_b" {
  role       = aws_iam_role.eks_node_role_b.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_security_group" "eks_nodes_b" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-eks-nodes-b-sg"
  }
}
