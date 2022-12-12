resource "aws_security_group" "lb_sg" {
  count = var.create_sg ? 1 : 0

  vpc_id = var.vpc_id
  name   = var.lb_sg_name
}

resource "aws_security_group_rule" "http_ingress" {
  count = var.http_enabled ? 1 : 0

  type              = "ingress"
  description       = "Inbound traffic to the web server port"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg[0].id
}

resource "aws_security_group_rule" "api_lb_sg" {
  count = var.api_port_enabled ? 1 : 0

  description       = ""
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg[0].id
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg[0].id
}

resource "aws_alb" "ecs_alb" {
  count = var.create_alb ? 1 : 0

  name               = var.lb_name
  load_balancer_type = var.load_balancer_type
  internal           = var.internal

  security_groups = [aws_security_group.lb_sg[0].id]
  ip_address_type = var.ip_address_type
  subnets         = var.subnet_ids
}

resource "aws_lb_target_group" "tg" {
  name        = "ecs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group" "tg_api" {
  name        = "ecs-tg-api"
  port        = 8081
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.ecs_alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_alb.ecs_alb[0].arn
  port              = 8081
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_api.arn
  }
}

resource "aws_lb_listener_rule" "api_listener_employees" {
  listener_arn = aws_lb_listener.api_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_api.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/employee"]
    }
  }
}

output "lb_tg_arn" {
  value = aws_lb_target_group.tg.arn
}

output "lb_tg_api_arn" {
  value = aws_lb_target_group.tg_api.arn
}

output "lb_dns_name" {
  value = aws_alb.ecs_alb[0].dns_name
}

output "lb_zone_id" {
  value = aws_alb.ecs_alb[0].zone_id
}

output "alb_sg_id" {
  value = aws_security_group.lb_sg[0].id
}