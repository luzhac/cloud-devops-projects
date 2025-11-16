resource "aws_lb_target_group" "ingress_http" {
  name        = "ingress-nodeport-32457"
  port        = 32457
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path     = "/"
    port     = "32457"
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "ingress_http_attach" {
  target_group_arn = aws_lb_target_group.ingress_http.arn
  target_id        = var.target_id
  port             = 32457
}
