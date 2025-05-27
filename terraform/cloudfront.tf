# CloudFront origin access control for S3 origin type with always signing using sigv4 protocol
resource "aws_cloudfront_origin_access_control" "website_origin_access_control" {
  name                              = "${var.domain_name} Access Control Policy"
  description                       = "Cloudfront access control policy for the ${var.domain_name} distribution."
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution with S3 origin, HTTPS redirect, IPv6 enabled, no cache, and ACM SSL certificate.
resource "aws_cloudfront_distribution" "cdn_static_website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["${var.domain_name}", "www.${var.domain_name}"]
  price_class         = "PriceClass_100"
  wait_for_deployment = true

  origin {
    domain_name              = aws_s3_bucket.s3-bucket.bucket_regional_domain_name
    origin_id                = var.domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.website_origin_access_control.id
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.domain_name
    smooth_streaming       = false

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.certificate.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  custom_error_response {
    error_code         = "404"
    response_code      = "200"
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code         = "403"
    response_code      = "200"
    response_page_path = "/index.html"
  }
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "cloudfront OAC"
  description                       = "description OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "cache_policy" {
  name = "Managed-CachingOptimized"
}

# Output the CloudFront distribution URL using the domain name of the cdn_static_website resource.
output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn_static_website.domain_name
}