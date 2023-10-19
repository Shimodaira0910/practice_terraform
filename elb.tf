# -----------------------
# ALB
# -----------------------

resource "aws_lb" "alb" {
  name               = "${var.project}-${var.enviroment}-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.web_sg.id
  ]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]

}

resource "aws_lb_listener" "aws_lb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_gruop.arn
  }
}

resource "aws_lb_listener" "aws_lb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.tokyo_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_gruop.arn
  }
}

# -----------------------
# Target Group
# -----------------------
resource "aws_lb_target_group" "alb_target_gruop" {
  name     = "${var.project}-${var.enviroment}-app-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.enviroment}-app-tg"
    project = var.project
    Env     = var.enviroment
    Type    = "app"
  }
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.alb_target_gruop.arn
  target_id        = aws_instance.app_server.id
}

