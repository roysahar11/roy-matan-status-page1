terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ecs = var.aws_endpoint
    sts = var.aws_endpoint
    iam = var.aws_endpoint
    ec2 = var.aws_endpoint
    rds = var.aws_endpoint
    elasticloadbalancing = var.aws_endpoint
    route53 = var.aws_endpoint
    cloudwatch = var.aws_endpoint
  }
} 