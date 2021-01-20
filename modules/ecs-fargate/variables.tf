# VPC Variables

variable "vpc_id" {
}

variable "public_subnets" {
}

variable "private_subnets" {
}

# ECS Service Variables

variable "service_name" {
}

variable "service_container_image" {
}

variable "service_container_cpu" {
}

variable "service_container_memory" {
}

variable "service_container_port" {
}

variable "service_host_port" {
}


variable "service_count" {
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
