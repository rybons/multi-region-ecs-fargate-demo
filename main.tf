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
  service_cpu             = 256
  service_count           = 3

  api_global_subdomain    = "api"
}

module "vpc-east" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name = "ecs-fargate-east"
  cidr = "10.70.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  private_subnets = ["10.70.1.0/24", "10.70.2.0/24", "10.70.3.0/24", "10.70.4.0/24", "10.70.5.0/24", "10.70.6.0/24"]
  public_subnets  = ["10.70.101.0/24", "10.70.102.0/24", "10.70.103.0/24", "10.70.104.0/24", "10.70.105.0/24", "10.70.106.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Environment = "dev-east"
  }

  providers = {
    aws = aws.east
  }
}

module "vpc-west" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ecs-fargate-west"
  cidr = "10.80.0.0/16"

  azs             = ["us-west-1a", "us-west-1c"]
  private_subnets = ["10.80.1.0/24", "10.80.2.0/24"]
  public_subnets  = ["10.80.101.0/24", "10.80.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Environment = "dev-west"
  }

  providers = {
    aws = aws.west
  }
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

  route53_hosted_zone_id        = var.route53_hosted_zone_id
  route53_api_global_subdomain  = local.api_global_subdomain
  route53_api_subdomain         = "api-us-east"

  vpc_id                    = module.vpc-east.vpc_id
  private_subnets           = module.vpc-east.private_subnets
  public_subnets            = module.vpc-east.public_subnets

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

  route53_hosted_zone_id        = var.route53_hosted_zone_id
  route53_api_global_subdomain  = local.api_global_subdomain
  route53_api_subdomain         = "api-us-west"

  vpc_id                    = module.vpc-west.vpc_id
  private_subnets           = module.vpc-west.private_subnets
  public_subnets            = module.vpc-west.public_subnets

  tag_environment = "dev-west"

  providers = {
    aws = aws.west
  }
}

module "route53-multi-region" {
  source = "./modules/route53-multi-region"

  api_endpoint_a        = module.ecs-east.route53_endpoint
  api_endpoint_b        = module.ecs-west.route53_endpoint

  route53_hosted_zone_id  = var.route53_hosted_zone_id
  route53_api_subdomain   = local.api_global_subdomain

  providers = {
    aws = aws.east
  }
}