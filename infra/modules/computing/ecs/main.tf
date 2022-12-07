resource "aws_lb_target_group" "tg" {
  name = "ecs-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"
} 

resource "aws_lb_target_group" "tg_api" {
  name = "ecs-tg-api"
  port = 8081
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port = 8081
  protocol = "HTTP"

  default_action {
   type = "forward"
   target_group_arn = aws_lb_target_group.tg_api.arn 
  }
}

resource "aws_lb_listener_rule" "api_listener_employees" {
  listener_arn = aws_lb_listener.api_listener.arn
  
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg_api.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/employee"]
    }
  }
}

resource "aws_alb" "ecs_alb" {
  name = "ecs-alb"
  load_balancer_type = "application"
  internal = false
  security_groups = [aws_security_group.alb_sg.id]
  ip_address_type = "ipv4"
  subnets = [var.ecs_sub_id, var.ecs_sub_two_id]

  
}

resource "aws_security_group" "alb_sg" {
  name = "alb_sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Inbound traffic to the Web Server Port"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Inbound traffic to the API Server Port"
    protocol    = "tcp"
    from_port   = 8081
    to_port     = 8081
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "ecs_fargate" {
  name = "my-cluster"
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id                    = "ami-0fd6a5614931e9e58"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  instance_type               = "t3.small"
  user_data                   = <<EOF
#!/bin/bash
# The cluster this agent should tck into.
echo 'ECS_CLUSTER=my-cluster' >> /etc/ecs/ecs.config
# Disable privileged containers.
echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config
EOF
  associate_public_ip_address = true

  key_name = "MSKKeyPair"

  security_groups = [var.api_sg_id]
}

resource "aws_autoscaling_group" "ecs_cluster" {
  name_prefix          = "asg"
  vpc_zone_identifier  = [var.ecs_sub_id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"

  target_group_arns = [aws_lb_target_group.tg.arn, aws_lb_target_group.tg_api.arn]
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "service"
  task_role_arn = "arn:aws:iam::342715877717:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::342715877717:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
      name      = "api"
      image     = "342715877717.dkr.ecr.eu-west-2.amazonaws.com/enimapod-app-ecr-repository:latest"
      memory    = 512
      cpu       = 512
      essential = true
      portMappings = [
        {
          containerPort = 8081
          hostPort      = 8081
        }
      ]
      logConfiguration = {
        logDriver : "awslogs",
        options = {
          awslogs-region = "eu-west-2",
          awslogs-group  = "/ecs/service/api"
        }
      }
    }
       ,
     {
        name = "server"
        image = "342715877717.dkr.ecr.eu-west-2.amazonaws.com/enimapod-web-server-repository:latest"
        memory = 512
        cpu = 512
        essential = true
        portMappings = [
          {
            containerPort = 80
            hostPort = 80
          }
        ]
        logConfiguration = {
                  logDriver : "awslogs",
                  options = {
                    awslogs-region = "eu-west-2",
                    awslogs-group  = "/ecs/service/web"
                  }
                }
      }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }
}


resource "aws_ecs_service" "worker" {
  name            = "service"
  cluster         = aws_ecs_cluster.ecs_fargate.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name = "server"
    container_port = 80
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_api.arn
    container_name = "api"
    container_port = 8081
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/service/api"
}

resource "aws_cloudwatch_log_group" "web_logs" {
  name = "/ecs/service/web"
}

output "lb_dns_name" {
  value = "${aws_alb.ecs_alb.dns_name}"
}

output "lb_zone_id" {
  value = "${aws_alb.ecs_alb.zone_id}"
}


