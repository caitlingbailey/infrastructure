# ACM certificate resource with the domain name and DNS validation method, supporting subject alternative names
resource "aws_acm_certificate" "certificate" {
  domain_name = var.domain_name
  provider    = aws.acm_provider
  subject_alternative_names = [
    "www.${var.domain_name}"
  ]
  validation_method = "EMAIL"
  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
  tags = {
    Name = "website-certificate"
  }
  lifecycle {
    create_before_destroy = true
  }

}

# ACM certificate validation resource using the certificate ARN and a list of validation record FQDNs.
resource "aws_acm_certificate_validation" "cert" {
  provider        = aws.acm_provider
  certificate_arn = aws_acm_certificate.certificate.arn
  # validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}