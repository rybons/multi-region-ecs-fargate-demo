# Route53 Variables

variable "route53_hosted_zone_id" {
}

# ElasticSearch Variables

variable "elasticsearch_version" {
  type = string
}

variable "elasticsearch_instance_type" {
  type = string
}

variable "elasticsearch_instance_count" {
  type = number
}

variable "elasticsearch_instance_volume_size" {
  type = number
}

variable "elasticsearch_az_count" {
  type = number
}

variable "elasticsearch_allowed_cidrs" {
  type = list(string)
}
