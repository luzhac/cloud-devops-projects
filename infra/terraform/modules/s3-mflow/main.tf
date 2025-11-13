

resource "aws_s3_bucket" "mlflow_artifacts" {
  bucket = "mlflow-artifacts-${random_string.suffix.id}"

  tags = {
    Name        = "mlflow-artifacts"
    Environment = "dev"
  }
}

# Random suffix to ensure bucket name is globally unique
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}


resource "aws_s3_bucket_public_access_block" "mlflow_block" {
  bucket                  = aws_s3_bucket.mlflow_artifacts.id
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
}


resource "aws_s3_bucket_versioning" "mlflow_versioning" {
  bucket = aws_s3_bucket.mlflow_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "mlflow_encryption" {
  bucket = aws_s3_bucket.mlflow_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "mlflow_lifecycle" {
  bucket = aws_s3_bucket.mlflow_artifacts.id

  rule {
    id     = "expire-old-artifacts"
    status = "Enabled"

    expiration {
      days = 180  # Delete after 6 months
    }
  filter {}
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}


