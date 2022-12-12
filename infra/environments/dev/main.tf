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
    key    = "dev-state"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "docker" {
  registry_auth {
    address  = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.main_vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}

resource "aws_subnet" "pub_subnets" {
  for_each = var.public_subnets

  availability_zone = each.value["availability_zone"]
  cidr_block        = each.value["cidr_block"]
  vpc_id            = local.aws_vpc_id

  tags = {
    "Name" = "${each.key}"
  }
}

resource "aws_subnet" "priv_subnets" {
  for_each = var.private_subnets

  availability_zone = each.value["availability_zone"]
  cidr_block        = each.value["cidr_block"]
  vpc_id            = local.aws_vpc_id

  tags = {
    "Name" = "${each.key}"
  }
}

resource "aws_internet_gateway" "gw" {
  count  = var.internet_gateway_addition ? 1 : 0
  vpc_id = local.aws_vpc_id
}

resource "aws_route_table" "public" {
  count  = var.route_table_addition ? 1 : 0
  vpc_id = local.aws_vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.aws_ig_id
  }
}

resource "aws_route_table_association" "rta" {
  for_each = aws_subnet.pub_subnets

  subnet_id      = each.value.id
  route_table_id = local.aws_rt_id

  depends_on = [
    aws_route_table.public
  ]
}

module "alb" {
  source             = "../../modules/networking/alb"
  vpc_id             = local.aws_vpc_id
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  ip_address_type    = var.lb_ip_address_type
  subnet_ids         = local.aws_pub_ids
  target_groups      = var.lb_target_groups
}

module "ecs" {
  source              = "../../modules/computing/ecs"
  vpc_id              = local.aws_vpc_id
  vpc_zone_identifier = local.aws_pub_ids
  alb_sg_id           = module.alb.alb_sg_id

  lb_tg_arn     = local.lb_tg_arn
  lb_tg_api_arn = local.lb_tg_api_arn
}

module "rds" {
  source    = "../../modules/data/rds"
  vpc_id    = local.aws_vpc_id
  ecs_sg_id = module.ecs.ecs_sg_id
  pub_rt_id = aws_route_table.public[0].id
}

data "aws_route53_zone" "enimapod" {
  name = "enimapod.co.uk."
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = data.aws_route53_zone.enimapod.zone_id
  name    = "enimapod.co.uk"
  type    = "A"


  alias {
    name                   = "dualstack.${module.alb.lb_dns_name}"
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "aaaa_route53_record" {
  zone_id = data.aws_route53_zone.enimapod.zone_id
  name    = "enimapod.co.uk"
  type    = "AAAA"


  alias {
    name                   = "dualstack.${module.alb.lb_dns_name}"
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = false
  }
}





