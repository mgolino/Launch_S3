

# Resource block to create S3 bucket
resource "random_string" "suffix" {
  length  = 8
  special = false
}

# Resource block to create S3 bucket with random suffix
resource "aws_s3_bucket" "mpgbucket" {
  bucket = "mpgbucket-${random_string.suffix.result}"
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "version_the_bucket" {
  bucket = aws_s3_bucket.mpgbucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_the_bucket" {
  bucket = aws_s3_bucket.mpgbucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional: Bucket policy for public read access (NOT RECOMMENDED for production)
resource "aws_s3_bucket_public_access_block" "block_the_bucket" {
  bucket = aws_s3_bucket.mpgbucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy_the_bucket" {
  bucket = aws_s3_bucket.mpgbucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = "${aws_s3_bucket.mpgbucket.arn}/*"
      }
    ]
  })
}
