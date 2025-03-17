terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9"
    }
  }

}

provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      Environment = var.environment
      Owner       = var.owner
    }
  }
}
