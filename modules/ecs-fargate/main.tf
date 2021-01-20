module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  name = var.cluster_name
  container_insights = true
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = {
    capacity_provider = var.cluster_capacity_provider
  }

  tags = {
    Environment = var.tag_environment
  }
}

data "template_file" "service" {
  template = "${file("${path.module}/templates/service.json.tpl")}"
  vars = {
    name            = var.service_name
    image           = var.service_container_image
    cpu             = var.service_container_cpu
    memory          = var.service_container_memory
    container_port  = var.service_container_port
    host_port       = var.service_host_port
  }
}

resource "aws_ecs_task_definition" "service" {
  family                = "service"
  container_definitions = data.template_file.service.rendered
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = module.ecs.this_ecs_cluster_arn
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
}
