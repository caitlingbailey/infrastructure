provider "aws" {
  region = var.default_region
  alias  = "use_default_region"
}

provider "aws" {
  alias  = "acm_provider"
  region = var.default_acm_region
}