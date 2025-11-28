output "vpc_id"            {
  value = aws_vpc.this.id
}


output "subnet_private_ids" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_d.id
  ]
}
output "subnet_public_ids" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_d.id
  ]
}
output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}
