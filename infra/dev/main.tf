terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }
  }

  backend "s3" {
    bucket = "enimapod-state"
    # name of folder - state. e.g. dev-state
    key    = "dev-state"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "docker" {
  registry_auth {
    address = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-2a"
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
}

resource "aws_ecs_cluster" "ecs_fargate" {
  name = "my-cluster"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "api_task" {
  name = "api-task-security-group"
  vpc_id = aws_vpc.main.id
  
  ingress {
    protocol = "tcp"
    from_port = 8081
    to_port = 8081
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id = "ami-0fd6a5614931e9e58"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  instance_type = "t2.micro"
  user_data = <<EOF
#!/bin/bash
# The cluster this agent should check into.
echo 'ECS_CLUSTER=my-cluster' >> /etc/ecs/ecs.config
# Disable privileged containers.
echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config
EOF
  associate_public_ip_address = true

  security_groups = [aws_security_group.api_task.id]
}

resource "aws_autoscaling_group" "ecs_cluster" {
  name_prefix = "asg"
  vpc_zone_identifier = [aws_subnet.public.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity = 2
  min_size = 1
  max_size = 3
  health_check_grace_period = 300
  health_check_type = "EC2"
}

resource "aws_ecr_repository" "this" {
  name = "enimapod-app-ecr-repository"

  tags = {
    Environment = "dev"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "service"
  container_definitions = jsonencode([
    {
      name = "service"
      image = "342715877717.dkr.ecr.eu-west-2.amazonaws.com/enimapod-app-ecr-repository:latest"
      cpu = 2
      memory = 512
      essential = true
      portMappings = [
        {
          containerPort = 8081
          hostPort = 8081
        }
      ]
    }
  ])
  volume {
    name = "service-storage"
    host_path = "/ecs/service-storage"
  }
}

resource "aws_ecs_service" "worker" {
  name = "service"
  cluster = aws_ecs_cluster.ecs_fargate.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count = 2
  }