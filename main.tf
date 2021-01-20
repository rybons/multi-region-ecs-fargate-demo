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

module "ecs-east" {
  source          = "./modules/ecs-fargate"
  tag_environment = "dev-east"

  providers = {
    aws = aws.east
  }
}

module "ecs-west" {
  source          = "./modules/ecs-fargate"
  tag_environment = "dev-west"

  providers = {
    aws = aws.west
  }
}
