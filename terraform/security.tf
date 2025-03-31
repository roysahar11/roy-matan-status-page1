# Security group for the nginx container
resource "aws_security_group" "status_page_app_production" {
  name        = "roymatan-status-page-production-app-sg"
  description = "Security group for Roy Matan Status Page nginx container"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "roymatan-status-page-production-app-sg"
    Owner = "roysahar"
  }
} 

resource "aws_security_group" "production_redis" {
  name        = "roymatan-status-page-production-redis-sg"
  description = "Security group for Roy Matan Status Page Redis cluster"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.status_page_app_production.id]
  }

  tags = {
    Name  = "roymatan-status-page-redis-sg"
    Owner = "roysahar"
  }
}