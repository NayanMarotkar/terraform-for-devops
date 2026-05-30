terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region   # Change to your preferred region (e.g., us-east-1, eu-west-1)
}
