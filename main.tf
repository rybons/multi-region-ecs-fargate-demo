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
  service_name            = "nginx-hello"
  service_container_image = "nginxdemos/hello"
  service_container_port  = 80
  service_host_port       = 80
  service_memory          = 512
  service_cpu             = 128
  service_count           = 3
}

module "ecs-east" {
  source          = "./modules/ecs-fargate"

  service_name              = local.service_name
  service_container_image   = local.service_container_image
  service_container_cpu     = local.service_cpu
  service_container_memory  = local.service_memory
  service_container_port    = local.service_container_port
  service_host_port         = local.service_host_port
  service_count             = local.service_count

  tag_environment = "dev-east"

  providers = {
    aws = aws.east
  }
}

module "ecs-west" {
  source          = "./modules/ecs-fargate"

  service_name              = local.service_name
  service_container_image   = local.service_container_image
  service_container_cpu     = local.service_cpu
  service_container_memory  = local.service_memory
  service_container_port    = local.service_container_port
  service_host_port         = local.service_host_port
  service_count             = local.service_count

  tag_environment = "dev-west"

  providers = {
    aws = aws.west
  }
}
