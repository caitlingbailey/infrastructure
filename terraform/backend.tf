terraform {
  backend "s3" {
    bucket         = "caitlingbailey.com-terraform"
    region         = "eu-west-1"
    key            = "Non-Modularized/S3-Static-Website/terraform.tfstate"
    encrypt        = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}