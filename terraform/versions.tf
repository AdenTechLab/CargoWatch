
terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket       = "cargowatch-terraform-state-472238086415"
    key          = "cargowatch/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
