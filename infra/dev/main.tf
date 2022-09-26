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

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_ecr_repository" "this" {
#   count = 1
  #TODO: Change count to foreach [dev,pre-prod,prod]

  name = "enimapod-app-ecr-repository"

  tags = {
    Environment = "dev"
  }
}


