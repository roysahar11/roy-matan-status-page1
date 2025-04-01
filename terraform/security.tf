# Security group for the status page app tasks
resource "aws_security_group" "status_page_app_production" {
  name        = "roymatan-status-page-production-app-sg"
  description = "Security group for the Status Page app - production envieonment"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.production_alb.id]
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
  description = "Security group for production Redis cluster"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.status_page_app_production.id]
  }

  tags = {
    Name  = "roymatan-status-page-production-redis-sg"
    Owner = "roysahar"
  }
}

# Security group for RDS
resource "aws_security_group" "production_rds" {
  name        = "roymatan-status-page-production-rds-sg"
  description = "Security group for production RDS instance"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.status_page_app_production.id]
  }

  tags = {
    Name  = "roymatan-status-page-production-rds-sg"
    Owner = "roysahar"
  }
}

resource "aws_security_group" "production_alb" {
  name        = "roymatan-status-page-production-alb-sg"
  description = "Security group for the prooduction encironment Status Page ALB"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    description = "HTTP from Internet"
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
    Name  = "roymatan-status-page-production-alb-sg"
    Owner = "roysahar"
  }
}

resource "aws_security_group" "production_secrets_vpc_endpoint" {
  name        = "vpc-endpoint-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.production_vpc.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.status_page_app_production.id]
  }
}