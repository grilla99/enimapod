variable "vpc_id" {
  type        = string
  description = "The vpc ID in which to place the RDS cluster"
}

variable "ecs_sg_id" {
  type        = string
  description = "The ID of the security group of the inbound connecting ECS cluster"
}

variable "pub_rt_id" {
  type        = string
  description = "The ID of the public facing route table in the VPC"
}