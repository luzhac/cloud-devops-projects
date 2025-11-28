resource "aws_security_group" "sg" {
  name        = "${var.cluster_name}-sg"
  vpc_id      = var.vpc_id
  description = "Allow SSH and internal traffic"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


     ingress {
    from_port   = 5000
    to_port     = 33000
    protocol    = "tcp"
    cidr_blocks = ["90.251.112.52/32"]
    description = "Allow Grafana HTTP access "
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "efs_sg" {
  name        = "${var.cluster_name}-efs-sg"
  description = "Allow NFS access from node security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-efs-sg"
  }
}


resource "aws_security_group_rule" "allow_nfs_from_nodes" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.efs_sg.id


  cidr_blocks = [var.vpc_cidr_block]

  description = "Allow NFS from VPC CIDR"
}


resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound HTTP/HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_alb_to_nodeport" {

  type              = "ingress"
  description       = "Allow ALB to access NodePort"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  security_group_id = aws_security_group.sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}
