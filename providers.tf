terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # S3 Remote Backend Configuration
  backend "s3" {
    bucket         = "terraweek-state-nayan"
    key            = "dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
