terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Adjust to your required AWS provider version
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}