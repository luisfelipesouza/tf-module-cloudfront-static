output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.static_website[0].domain_name
}
