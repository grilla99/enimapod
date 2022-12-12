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

variable "allocated_storage" {
  type        = string
  default     = "200"
  description = "value"
}

variable "db_identifier" {
  type        = string
  default     = "dev"
  description = "value"
}

variable "db_engine" {
  type        = string
  default     = "mysql"
  description = "value"
}

variable "db_engine_version" {
  type        = string
  default     = "8.0.28"
  description = "value"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "value"
}

variable "db_username" {
  type        = string
  default     = "admin"
  description = "value"
}

variable "db_password" {
  type        = string
  default     = "testpassword"
  description = "value"
}

variable "db_network_type" {
  type        = string
  default     = "IPV4"
  description = "value"
}

variable "db_publicly_accessible" {
  type        = bool
  default     = true
  description = "value"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = true
  description = "value"
}