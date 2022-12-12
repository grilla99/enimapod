variable "create_alb" {
  type        = bool
  default     = true
  description = "value"
}

variable "lb_sg_name" {
  type        = string
  default     = "alb_sg"
  description = "value"
}

variable "vpc_id" {
  type        = string
  description = ""
}

variable "create_sg" {
  type        = bool
  default     = true
  description = "value"
}

variable "lb_name" {
  type        = string
  default     = "tf-lb"
  description = "value"
}

variable "load_balancer_type" {
  type        = string
  default     = "application"
  description = "value"
}

variable "internal" {
  type        = bool
  default     = false
  description = false
}

variable "http_enabled" {
  type        = bool
  default     = true
  description = "value"
}

variable "api_port_enabled" {
  type        = bool
  default     = true
  description = ""
}

variable "ip_address_type" {
  type        = string
  default     = "ipv4"
  description = "value"
}

variable "subnet_ids" {
  type        = list(any)
  description = "value"
}

variable "target_groups" {
  type        = map(any)
  description = ""
}

# variable "load_balancer_listener" {
#     type = map
#     description = ""
# }