data "aws_route53_zone" "hosted_zone" {
  zone_id = var.route53_hosted_zone_id
}

resource "aws_route53_record" "api-a" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.route53_api_subdomain
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "api-a"
  records        = [var.api_endpoint_a]
}

resource "aws_route53_record" "api-b" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.route53_api_subdomain
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "api-b"
  records        = [var.api_endpoint_b]
}
