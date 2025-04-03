terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "roymatan-status-page-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "roymatan-status-page-terraform-locks"
    dynamodb_table_name = "roymatan-status-page-terraform-locks"
    dynamodb_table_tags = {
      Name  = "roymatan-status-page-terraform-locks"
      Owner = "roysahar"
    }
    retry_max_attempts = 4
    retry_min_delay    = 5
    retry_max_delay    = 30
    dynamodb_table_ttl_attribute = "TimeToLive"
    dynamodb_table_ttl_enabled   = true
  }
}

provider "aws" {
  region = "us-east-1"
  
  # Skip unnecessary API calls
  skip_metadata_api_check     = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  # Cache API responses
  default_tags {
    tags = {
      Owner = "roysahar"
      ManagedBy = "terraform"
    }
  }
}

# provider "aws" {
#   access_key                  = "test"
#   secret_key                  = "test"
#   region                      = "us-east-1"

#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true

#   endpoints {
#     ecs = var.aws_endpoint
#     sts = var.aws_endpoint
#     iam = var.aws_endpoint
#     ec2 = var.aws_endpoint
#     rds = var.aws_endpoint
#     elasticloadbalancing = var.aws_endpoint
#     elasticloadbalancingv2 = var.aws_endpoint
#     route53 = var.aws_endpoint
#     cloudwatch = var.aws_endpoint
#     elasticache = var.aws_endpoint
#     secretsmanager = var.aws_endpoint
#     ecr = var.aws_endpoint
#   }
# } 