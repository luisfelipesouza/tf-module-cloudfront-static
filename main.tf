resource "aws_cloudfront_origin_access_identity" "origin_access" {
  comment = var.domain
}


//locals {
//  s3_origin_id = "myS3Origin"
//}

resource "aws_cloudfront_distribution" "static_website" {
  count = var.certificate_status == "ISSUED" ? 1 : 0

  enabled             = true
  comment             = "${var.domain} distribution"
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  aliases             = [var.domain]

  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.domain

    s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access.cloudfront_access_identity_path
    }
  }


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD","OPTIONS"]
    cached_methods   = ["GET", "HEAD","OPTIONS"]
    target_origin_id = var.domain

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn       = var.certificate_arn
    ssl_support_method        = "sni-only"
    minimum_protocol_version  = "TLSv1.2_2018"
  }

  tags = {
    stack         = lower(var.environment)
    application   = lower(var.application)
    cost-center   = lower(var.cost-center)
    deployed-by   = lower(var.deployed-by)
  }
}