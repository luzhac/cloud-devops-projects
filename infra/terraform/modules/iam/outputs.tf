output "instance_profile_name" {
  value = aws_iam_instance_profile.profile.name
}
output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}
