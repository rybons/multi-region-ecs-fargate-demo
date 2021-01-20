variable "cluster_name" {
  default = "ecs-cluster"
}

variable "capacity_provider" {
  default = "FARGATE_SPOT"
}

variable "tag_environment" {
  default = "Development"
}