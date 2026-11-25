
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "CargoWatch"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
