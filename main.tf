
resource "aws_s3_bucket" "mpgbucket1945" {
  bucket = "mpgbucket1945"

  tags = {
    Name        = "mpgbucket1945"
    Environment = "Dev"
  }
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "version_the_bucket" {
  bucket = aws_s3_bucket.mpgbucket1945.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_the_bucket" {
  bucket = aws_s3_bucket.mpgbucket1945.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional: Bucket policy for public read access (NOT RECOMMENDED for production)
resource "aws_s3_bucket_public_access_block" "block_the_bucket" {
  bucket = aws_s3_bucket.mpgbucket1945.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Example policy for objects in the bucket - this can be commented out
resource "aws_s3_bucket_policy" "policy_the_bucket" {
  bucket = aws_s3_bucket.mpgbucket1945.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = "${aws_s3_bucket.mpgbucket1945.arn}/*"
      }
    ]
  })
}
