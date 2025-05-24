variable "s3_name" {
  type = string
  default = "caitlingbailey-website"
}

variable "region" {
  type = string
  description = "The primary region where the website will be hosted."
  default = "eu-west-1"
}

variable "root_domain_name" {
  type = string
  description = "The domain name of the website."
  default = "caitlingbailey.com"
}

variable "cloudfront_price_class" {
  type        = string
  description = "The price class for the Cloudfront distribution. Valid entries are PriceClass_All, PriceClass_200, or PriceClass_100."
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.cloudfront_price_class)
    error_message = "Valid values for var: cloudfront_price_class are PriceClass_All, PriceClass_200, or PriceClass_100."
  }
}

variable "cloudfront_viewer_protocol_policy" {
  type        = string
  description = "[https-only, redirect-to-https]"
  default     = "https-only"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for resources created in module. Type is map so please use format: {\"key\"=\"value\"}"
  default     = {}
}