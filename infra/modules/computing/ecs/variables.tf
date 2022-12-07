variable "api_sg_id" {
  type        = string
  description = "The ID of the security group attached to the ECS cluster"
}

variable "ecs_sub_id" {
  type        = string
  description = "The subnet IDs in which to launch instances as part of the ECS cluster"
}

variable "ecs_sub_two_id" {
  type = string
}

variable "vpc_id" {
  type = string
}