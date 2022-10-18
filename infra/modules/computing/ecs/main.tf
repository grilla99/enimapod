resource "aws_ecs_cluster" "ecs_fargate" {
  name = "my-cluster"
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id                    = "ami-0fd6a5614931e9e58"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  instance_type               = "t3.micro"
  user_data                   = <<EOF
#!/bin/bash
# The cluster this agent should check into.
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
}

resource "aws_ecr_repository" "api" {
  name = "enimapod-app-ecr-repository"

  tags = {
    Environment = "dev"
  }
}

resource "aws_ecr_repository" "web" {
  name = "enimapod-web-server-repository"

  tags = {
    Environment = "dev"
  }
}

# Note to Aidan:
# API Task Works and Runs.
# To have both tasks running need an instance with 1024MB (t2.micro and larger??) - Double check this
# The configuration below is correct for the server but something to do with the Dockerfile / Nginx needs tweaking
resource "aws_ecs_task_definition" "task_definition" {
  family = "service"
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
          awslogs-group  = "/ecs/service"
        }
      }

    }
    #  ,
    # {
    #   name = "server"
    #   image = "342715877717.dkr.ecr.eu-west-2.amazonaws.com/enimapod-web-server-repository:latest"
    #   memory = 512
    #   essential = true
    #   portMappings = [
    #     {
    #       containerPort = 8080
    #       hostPort = 8080
    #     }
    #   ]
    # }
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
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/service"
}


