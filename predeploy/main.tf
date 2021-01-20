provider "aws" {
  region = "us-east-1"
}

module "tfstate-backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "0.29.0"

  enabled       = true
  environment   = "dev"
  name          = "multi-region-ecs-fargate-demo"
  stage         = "dev"
}