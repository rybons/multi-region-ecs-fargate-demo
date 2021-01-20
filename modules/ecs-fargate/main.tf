module "ecs" {

  source = "terraform-aws-modules/ecs/aws"
  name = var.cluster_name
  container_insights = true
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = {
    capacity_provider = var.capacity_provider
  }

  tags = {
    Environment = var.tag_environment
  }
}
