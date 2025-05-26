# ACM certificate resource with the domain name and DNS validation method, supporting subject alternative names
resource "aws_acm_certificate" "cert" {
  provider                  = aws.acm_provider
  domain_name               = var.domain_name
  validation_method         = "EMAIL"
  subject_alternative_names = ["*.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }
}

# ACM certificate validation resource using the certificate ARN and a list of validation record FQDNs.
resource "aws_acm_certificate_validation" "cert" {
  provider        = aws.acm_provider
  certificate_arn = aws_acm_certificate.cert.arn
  # validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}