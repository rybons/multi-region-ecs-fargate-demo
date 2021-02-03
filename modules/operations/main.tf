data "aws_route53_zone" "hosted_zone" {
  zone_id = var.route53_hosted_zone_id
}

module "elasticsearch" {
  source  = "cloudposse/elasticsearch/aws"
  version = "0.26.0"

  namespace               = "monitoring"
  stage                   = "operations"
  name                    = "es"
  dns_zone_id             = data.aws_route53_zone.hosted_zone.zone_id
  domain_hostname_enabled = true
  vpc_enabled             = false
  availability_zone_count = var.elasticsearch_az_count
  zone_awareness_enabled  = var.elasticsearch_instance_count == 1 ? false : true
  elasticsearch_version   = var.elasticsearch_version
  instance_type           = var.elasticsearch_instance_type
  instance_count          = var.elasticsearch_instance_count
  ebs_volume_size         = var.elasticsearch_instance_volume_size
  encrypt_at_rest_enabled = true
  kibana_subdomain_name   = "kibana-es"
  allowed_cidr_blocks     = var.elasticsearch_allowed_cidrs

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
}