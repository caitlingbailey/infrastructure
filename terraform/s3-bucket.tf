resource "aws_s3_bucket" "website" {
  bucket        = var.root_domain_name
  force_destroy = true
  tags = {
    Name = "website-bucket-s3-static-website"
  }
}

resource "aws_s3_bucket_public_access_block" "s3Public" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}

resource "aws_s3_bucket_website_configuration" "website-bucket-config" {
  bucket = aws_s3_bucket.website.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "website-bucket-versioning" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "website-bucket-lifecycle-rule" {
  bucket = aws_s3_bucket.website.id

  rule {
    id     = "delete versions"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 2
    }
  }
}

resource "aws_s3_bucket_policy" "website-bucket-policy" {
  bucket = aws_s3_bucket.website.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.website.arn}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.website_distribution.arn}"
            }
        }
    }
}

POLICY
}