resource "aws_vpc_endpoint" "production_secretsmanager" {
  vpc_id            = aws_vpc.production_vpc.id
  service_name      = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.production_private_a.id, aws_subnet.production_private_b.id]

  security_group_ids = [aws_security_group.production_vpc_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name  = "roymatan-status-page-production-secretsmanager-endpoint"
    Owner = "roysahar"
  }
}


# ECR API endpoint
resource "aws_vpc_endpoint" "production_ecr_api" {
  vpc_id             = aws_vpc.production_vpc.id
  service_name       = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.production_private_a.id, aws_subnet.production_private_b.id]
  security_group_ids = [aws_security_group.production_vpc_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name  = "roymatan-status-page-production-ecr-api-endpoint"
    Owner = "roysahar"
  }
}

# ECR DKR endpoint
resource "aws_vpc_endpoint" "production_ecr_dkr" {
  vpc_id             = aws_vpc.production_vpc.id
  service_name       = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.production_private_a.id, aws_subnet.production_private_b.id]
  security_group_ids = [aws_security_group.production_vpc_endpoints.id]

  private_dns_enabled = true

  tags = {
    Name  = "roymatan-status-page-production-ecr-dkr-endpoint"
    Owner = "roysahar"
  }
}

# S3 endpoint (Gateway type)
resource "aws_vpc_endpoint" "production_s3" {
  vpc_id            = aws_vpc.production_vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.production_private.id]

  tags = {
    Name  = "roymatan-status-page-production-s3-vpc-endpoint"
    Owner = "roysahar"
  }
}

# CloudWatch Logs VPC Endpoint
resource "aws_vpc_endpoint" "production_cloudwatch_logs" {
  vpc_id             = aws_vpc.production_vpc.id
  service_name       = "com.amazonaws.us-east-1.logs"
  vpc_endpoint_type  = "Interface"
  private_dns_enabled = true
  subnet_ids         = [aws_subnet.production_private_a.id, aws_subnet.production_private_b.id]
  security_group_ids = [aws_security_group.production_vpc_endpoints.id]

  tags = {
    Name  = "roymatan-status-page-production-cloudwatch-logs-endpoint"
    Owner = "roysahar"
  }
}