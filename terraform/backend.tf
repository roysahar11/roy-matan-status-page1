# S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "roymatan-status-page-terraform-state"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name  = "roymatan-status-page-terraform-state"
    Owner = "roysahar"
  }
}

# Enable versioning for state files
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "roymatan-status-page-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Add TTL to automatically expire locks
  ttl {
    attribute_name = "TimeToLive"
    enabled       = true
  }

  # Add a TTL attribute
  attribute {
    name = "TimeToLive"
    type = "N"
  }

  tags = {
    Name  = "roymatan-status-page-terraform-locks"
    Owner = "roysahar"
  }
}

# Add a DynamoDB table item to set TTL
resource "aws_dynamodb_table_item" "lock_ttl" {
  table_name = aws_dynamodb_table.terraform_locks.name
  hash_key   = aws_dynamodb_table.terraform_locks.hash_key
  item = jsonencode({
    LockID = {
      S = "terraform-state-lock"
    }
    TimeToLive = {
      N = tostring(timeadd(timestamp(), "20m")) # Lock expires after 15 minutes
    }
  })
} 