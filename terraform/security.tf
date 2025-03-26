# Security group for the nginx container
resource "aws_security_group" "status_page_nginx" {
  name        = "roymatan-status-page-nginx-sg"
  description = "Security group for Roy Matan Status Page nginx container"
  vpc_id      = aws_vpc.status_page_vpc.id

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
    Name  = "roymatan-status-page-nginx-sg"
    Owner = "roysahar"
  }
} 