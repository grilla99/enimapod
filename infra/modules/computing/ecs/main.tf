resource "aws_security_group" "api_task" {
  name   = "api-task-security-group"
  vpc_id = var.vpc_id

  ingress {
    description = "Inbound traffic to the API port"
    protocol    = "tcp"
    from_port   = 8081
    to_port     = 8081
    security_groups = [var.alb_sg_id]
  }

  ingress {
    description = "Inbound traffic to the Web Server Port"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    security_groups = [var.alb_sg_id]
  }

  ingress {
    description = "HTTPs traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}


resource "aws_launch_configuration" "ecs_launch_config" {
  image_id                    = var.ecs_image_id
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  instance_type               = var.ecs_instance_type
  associate_public_ip_address = var.ecs_associate_public_ip

  key_name = var.ecs_key_pair_name

  user_data = var.ecs_user_data

  security_groups = [aws_security_group.api_task.id]
}

resource "aws_autoscaling_group" "ecs_cluster" {
  name_prefix          = var.asg_name_prefix
  vpc_zone_identifier  = var.vpc_zone_identifier
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = var.asg_desired_capacity
  min_size                  = var.asg_min_capacity
  max_size                  = var.asg_max_capacity
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type

  target_group_arns = [var.lb_tg_arn, var.lb_tg_api_arn]
}

resource "aws_ecs_task_definition" "task_definition" {
  family             = var.task_family
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
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
      name      = "server"
      image     = "342715877717.dkr.ecr.eu-west-2.amazonaws.com/enimapod-web-server-repository:latest"
      memory    = 512
      cpu       = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
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
    name      = var.volume_name
    host_path = var.volume_host_path
  }
}


resource "aws_ecs_service" "worker" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = var.lb_tg_arn
    container_name   = "server"
    container_port   = 80
  }

  load_balancer {
    target_group_arn = var.lb_tg_api_arn
    container_name   = "api"
    container_port   = 8081
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/service/api"
}

resource "aws_cloudwatch_log_group" "web_logs" {
  name = "/ecs/service/web"
}

output "ecs_sg_id" {
  value = aws_security_group.api_task.id
}

