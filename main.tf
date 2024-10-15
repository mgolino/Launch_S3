# Terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Adjust to your required AWS provider version
    }
  }
}

# Provider block
provider "aws" {
  region = "us-west-2"  # Change this to your desired AWS region
}

# Resource block to create S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-unique-bucket-name-${random_string.suffix.result}"  # Ensure the name is globally unique
}

# Random string for unique bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional: Bucket policy for public read access (NOT RECOMMENDED for production)
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.example_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = "${aws_s3_bucket.example_bucket.arn}/*"
      }
    ]
  })
}
