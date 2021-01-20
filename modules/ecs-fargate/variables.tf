# ECS Service Variables

variable "service_name" {
}

variable "service_container" {
}

# ECS Cluster Variables

variable "cluster_name" {
  default = "ecs-cluster"
}

variable "cluster_capacity_provider" {
  default = "FARGATE_SPOT"
}

# Tags

variable "tag_environment" {
  default = "Development"
}
