resource "aws_vpc_endpoint" "production_secretsmanager" {
  vpc_id            = aws_vpc.production_vpc.id
  service_name      = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.production_private_a.id, aws_subnet.production_private_b.id]

  security_group_ids = [aws_security_group.production_secrets_vpc_endpoint.id]

  private_dns_enabled = true

  tags = {
    Name  = "roymatan-status-page-production-secretsmanager-endpoint"
    Owner = "roysahar"
  }
}