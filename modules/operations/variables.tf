# IAM Variables

variable "allowed_iam_users" {
  type = list(string)
}

# VPC Variables

variable "vpc_id" {
}

variable "public_subnets" {
}

variable "private_subnets" {
}

# Route53 Variables

variable "route53_hosted_zone_id" {
}

# ElasticSearch Variables

variable "elasticsearch_version" {
}

variable "elasticsearch_instance_type" {
}

variable "elasticsearch_instance_count" {
}

variable "elasticsearch_instance_volume_size" {
}

variable "elasticsearch_az_count" {
}
