variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "terraform_state_bucket_name" {
  type        = string
  description = "The name of the bucket designated for terraform state."
}

variable "default_region" {
  type        = string
  description = "The default AWS region for resources to be created."
}

variable "default_acm_region" {
  type        = string
  description = "The default AWS region for the ACM provider."
}

variable "common_tags" {
  description = "Common tags you want applied to all components."
}