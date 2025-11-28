output "security_group_node_id" {
  value = aws_security_group.sg.id
}

output "security_group_efs_id" {
  value = aws_security_group.efs_sg.id
}

output "security_group_alb_id" {
  value = aws_security_group.alb_sg.id
}


