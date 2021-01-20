terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

locals {
  service_name      = "nginx-hello"
  service_container = "nginxdemos/hello"
}

module "ecs-east" {
  source          = "./modules/ecs-fargate"

  service_name      = local.service_name
  service_container = local.service_container

  tag_environment = "dev-east"

  providers = {
    aws = aws.east
  }
}

module "ecs-west" {
  source          = "./modules/ecs-fargate"

  service_name      = local.service_name
  service_container = local.service_container

  tag_environment = "dev-west"

  providers = {
    aws = aws.west
  }
}
