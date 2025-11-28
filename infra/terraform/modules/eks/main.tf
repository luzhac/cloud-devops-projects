#####################################
# EKS Cluster
#####################################
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  version = "1.33"

  access_config {
    authentication_mode = "API"
  }

}

#####################################
# EKS Node Group
#####################################
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "default"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  instance_types = ["t4g.medium"]
  ami_type       = "AL2023_ARM_64_STANDARD"

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${var.cluster_name}-node"
  }

  capacity_type = "ON_DEMAND"
  disk_size     = 30
}

#####################################
# Current caller IAM
#####################################
data "aws_caller_identity" "current" {}

#####################################
# Access Entry for admin
#####################################
resource "aws_eks_access_entry" "admin_access" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"
}

#####################################
# Access Policy Association for admin
#####################################
resource "aws_eks_access_policy_association" "admin_policy" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = data.aws_caller_identity.current.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.admin_access
  ]
}
