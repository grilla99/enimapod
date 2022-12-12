variable "cluster_name" {
  type        = string
  default     = "ecs-tf-cluster"
  description = "value"
}

variable "vpc_id" {
  type        = string
  description = "value"
}

variable "ecs_image_id" {
  type        = string
  default     = "ami-0fd6a5614931e9e58"
  description = "value"
}

variable "ecs_instance_type" {
  type        = string
  default     = "t3.small"
  description = "value"
}

variable "ecs_user_data" {
  type        = string
  default     = <<EOF
    #!/bin/bash
    # The cluster this agent should tck into.
    echo 'ECS_CLUSTER=ecs-tf-cluster' >> /etc/ecs/ecs.config
    # Disable privileged containers.
    echo 'ECS_DISABLE_PRIVILEGED=true' >> /etc/ecs/ecs.config
    EOF 
  description = "value"
}

variable "ecs_associate_public_ip" {
  type        = bool
  default     = true
  description = ""
}

variable "ecs_key_pair_name" {
  type        = string
  default     = "MSKKeyPair"
  description = "value"
}

variable "vpc_zone_identifier" {
  type        = list(any)
  description = ""
}

variable "asg_name_prefix" {
  type        = string
  default     = "ecs-asg"
  description = "value"
}

variable "asg_desired_capacity" {
  type        = string
  default     = "1"
  description = "value"
}

variable "asg_min_capacity" {
  type        = string
  default     = "1"
  description = "value"
}

variable "asg_max_capacity" {
  type        = string
  default     = "3"
  description = "value"
}

variable "asg_health_check_grace_period" {
  type        = string
  default     = "300"
  description = "value"
}

variable "asg_health_check_type" {
  type        = string
  default     = "EC2"
  description = "value"
}

variable "lb_tg_arn" {
  type        = string
  description = "value"
}

variable "lb_tg_api_arn" {
  type        = string
  description = "value"
}

variable "task_family" {
  type        = string
  default     = "web-application"
  description = "value"
}

variable "task_role_arn" {
  type        = string
  default     = "arn:aws:iam::342715877717:role/ecsTaskExecutionRole"
  description = "value"
}

variable "execution_role_arn" {
  type        = string
  default     = "arn:aws:iam::342715877717:role/ecsTaskExecutionRole"
  description = "value"
}

variable "volume_name" {
  type        = string
  default     = "service-storage"
  description = "value"
}

variable "volume_host_path" {
  type        = string
  default     = "/ecs/service-storage"
  description = "value"
}

variable "service_name" {
  type        = string
  default     = "web-application"
  description = "value"
}

variable "desired_count" {
  type        = string
  default     = "1"
  description = "value"
}

