output "app_public_ips" {
  description = "Public IPs of the app instances"
  value       = aws_instance.app[*].public_ip
}

output "app_instance_ids" {
  description = "IDs of the app instances"
  value       = aws_instance.app[*].id
}
