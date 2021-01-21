data "aws_caller_identity" "iam" {}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_route53_zone" "hosted_zone" {
  zone_id = var.route53_hosted_zone_id
}

module "iam_assumable_role_custom" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.iam.account_id}:root",
  ]

  create_role = true

  role_name         = "observability-admin"
  role_requires_mfa = false

  custom_role_policy_arns = [
  ]
}

module "iam_group_with_assumable_roles_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 3.0"

  name = "observability-admins"

  assumable_roles = [
    module.iam_assumable_role_custom.this_iam_role_arn
  ]

  group_users = var.allowed_iam_users
}

resource "aws_security_group" "es-ingress" {
  name        = "es-ingress"
  description = "ElasticSearch Security Group"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "es-ingress"
  }
}

module "elasticsearch" {
  source  = "cloudposse/elasticsearch/aws"
  version = "0.26.0"

  namespace               = "monitoring"
  stage                   = "operations"
  name                    = "es"
  dns_zone_id             = data.aws_route53_zone.hosted_zone.zone_id
  security_groups         = [aws_security_group.es-ingress.id]
  vpc_id                  = data.aws_vpc.vpc.id
  subnet_ids              = slice(var.public_subnets, 1, var.elasticsearch_az_count + 1)
  availability_zone_count = var.elasticsearch_az_count
  zone_awareness_enabled  = var.elasticsearch_instance_count == 1 ? false : true
  elasticsearch_version   = var.elasticsearch_version
  instance_type           = var.elasticsearch_instance_type
  instance_count          = var.elasticsearch_instance_count
  ebs_volume_size         = var.elasticsearch_instance_volume_size
  iam_role_arns           = [module.iam_assumable_role_custom.this_iam_role_arn]
  iam_actions             = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
  encrypt_at_rest_enabled = true
  kibana_subdomain_name   = "kibana-es"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
}