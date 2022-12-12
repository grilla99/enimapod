# variable "" {
#     type = ""
#     default = ""
#     description = ""
# }

variable "main_vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The primary IPv4 CIDR block of the VPC to place resources in"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Set `true` to enable [DNS hostnames](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-dns.html#vpc-dns-hostnames) in the VPC"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Set `true` to enable DNS resolution in the VPC through the Amazon provided DNS server"
}

variable "public_subnets" {
  type = map(any)
  default = {
    pub-1 = {
      availability_zone = "eu-west-2a"
      cidr_block        = "10.0.0.0/24"
    }
    pub-2 = {
      availability_zone = "eu-west-2b"
      cidr_block        = "10.0.2.0/24"
    }
  }
  description = "value"
}

variable "private_subnets" {
  type = map(any)
  default = {
    priv-1 = {
      availability_zone = "eu-west-2a"
      cidr_block        = "10.0.1.0/24"
    }
  }
  description = "value"
}

variable "internet_gateway_addition" {
  type        = bool
  default     = true
  description = "value"
}

variable "route_table_addition" {
  type        = bool
  default     = true
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
  description = "value"
}

variable "lb_target_groups" {
  type = map(any)
  default = {
    port-80-tg = {
      name        = "ecs-tg-web"
      port        = "80"
      protocol    = "HTTP"
      target_type = "instance"
    }
    port-8081-tg = {
      name        = "ecs-tg-api"
      port        = "8081"
      protocol    = "HTTP"
      target_type = "instance"
    }
  }
  description = ""
}

variable "lb_ip_address_type" {
  type        = string
  default     = "ipv4"
  description = "value"
}

