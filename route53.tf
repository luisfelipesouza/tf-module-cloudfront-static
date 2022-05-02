resource "aws_route53_record" "root" {
  count = var.domain != "" ? 1 : 0
  
  zone_id = var.hosted_zone_id
  name    = "${var.domain}."
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_website[0].domain_name
    zone_id                = aws_cloudfront_distribution.static_website[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_root" {
  count = var.domain != "" ? 1 : 0

  zone_id = var.hosted_zone_id
  name    = "www.${var.domain}."
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_website[0].domain_name
    zone_id                = aws_cloudfront_distribution.static_website[0].hosted_zone_id
    evaluate_target_health = false
  }
}