# Creating S3 bucket and apply force destroy So, when going to destroy it won't throw error 'Bucket is not empty'
resource "aws_s3_bucket" "s3-bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

# Keeping S3 bucket private
resource "aws_s3_bucket_public_access_block" "website_bucket_access" {
  bucket                  = aws_s3_bucket.s3-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "website-bucket-config" {
  bucket = aws_s3_bucket.s3-bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "website-bucket-versioning" {
  bucket = aws_s3_bucket.s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "website-bucket-policy" {
  bucket = aws_s3_bucket.s3-bucket.id
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
        "Resource": "${aws_s3_bucket.s3-bucket.arn}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.cdn_static_website.arn}"
            }
        }
    }
}

POLICY
}