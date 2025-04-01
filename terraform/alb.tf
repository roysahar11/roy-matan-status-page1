# Application Load Balancer
resource "aws_lb" "production" {
  name               = "roymatan-status-page-production-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.production_alb.id]
  subnets           = [aws_subnet.production_public.id] # You might need multiple subnets for HA

  tags = {
    Name  = "status-page-alb"
    Owner = "roysahar"
  }
}

# Target Group
resource "aws_lb_target_group" "status_page_tg" {
  name        = "status-page-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.production.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200"
    path               = "/health/"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name  = "status-page-target-group"
    Owner = "roysahar"
  }
}

# ALB Listener
resource "aws_lb_listener" "status_page" {
  load_balancer_arn = aws_lb.status_page_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.status_page_tg.arn
  }
}