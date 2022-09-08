terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
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

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}