output "route53_endpoint" {
  value = aws_route53_record.api.name
}