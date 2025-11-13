############################################################
# Ubuntu 22.04 ARM64 AMI
############################################################
data "aws_ami" "ubuntu_arm" {
  owners = ["099720109477"]

  filter {
    name   = "image-id"
    values = ["ami-0eecf0ae30ebe8971"]
  }
}


locals {
  ami_id = data.aws_ami.ubuntu_arm.id
}

############################################################
# EC2 Instances (Master / App / Monitor)
############################################################

# Master node
resource "aws_instance" "master" {
  ami                         = local.ami_id
  instance_type               = "t4g.small"
  subnet_id                   = var.subnet_public_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name

  root_block_device {
    volume_size           = 20

    delete_on_termination = true
  }

  tags = {
    Name = "${var.cluster_name}-master"
    Role = "master"
  }
}

# App node
resource "aws_instance" "app" {
  ami                         = local.ami_id
  instance_type               = "t4g.small"
  subnet_id                   = var.subnet_public_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  depends_on                  = [aws_instance.master]

  root_block_device {
    volume_size           = 20

    delete_on_termination = true
  }

  tags = {
    Name = "${var.cluster_name}-app"
    Role = "app"
  }
}




# Monitor node
resource "aws_instance" "monitor" {
  ami                         = local.ami_id
  instance_type               = "t4g.small"
  subnet_id                   = var.subnet_private_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  depends_on                  = [aws_instance.master]

    root_block_device {
    volume_size           = 30

    delete_on_termination = true
  }

  tags = {
    Name = "${var.cluster_name}-monitor"
    Role = "monitor"
  }
}

