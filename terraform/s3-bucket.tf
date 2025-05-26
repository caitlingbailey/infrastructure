# Creating S3 bucket and apply force destroy So, when going to destroy it won't throw error 'Bucket is not empty'
resource "aws_s3_bucket" "s3-bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "s3-bucket-test" {
  bucket        = "caitlingbailey-test"
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

# This Terraform code defines an IAM policy document that allows CloudFront to access objects in the S3 bucket
data "aws_iam_policy_document" "website_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3-bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.cdn_static_website.arn]
    }
  }
}

# Creating the S3 policy and applying it for the S3 bucket
resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.s3-bucket.id
  policy = data.aws_iam_policy_document.website_bucket.json
}