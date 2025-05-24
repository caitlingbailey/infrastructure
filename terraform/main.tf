provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "cloudfront-certificate"
  region = "eu-west-1"
}