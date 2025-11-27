data "aws_ami" "eks_arm" {
  owners      = ["602401143452"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-al2023-arm64-standard-1.34-v20251120"]
  }
}

# App node

resource "aws_instance" "app" {
  count                       = 2
  ami = data.aws_ami.eks_arm.id

  instance_type               = "t4g.small"
  subnet_id                   = var.subnet_public_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name

  user_data = <<-EOF
  #!/bin/bash
  /etc/eks/bootstrap.sh ${var.cluster_name}
  EOF

  root_block_device {
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name = "${var.cluster_name}-app-${count.index}"
    Role = "app"
  }
}


