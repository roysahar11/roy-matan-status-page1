# Application Load Balancer
resource "aws_lb" "production" {
  name               = "roymatan-production-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.production_alb.id]
  subnets           = [aws_subnet.production_public_a.id, aws_subnet.production_public_b.id]

  tags = {
    Name  = "roymatan-status-page-production-alb"
    Owner = "roysahar"
  }
}

# Target Group
resource "aws_lb_target_group" "production_alb_tg" {
  name        = "roymatan-production-alb-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.production_vpc.id
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
    Name  = "roymatan-status-page-production-alb-tg"
    Owner = "roysahar"
  }
}

# ALB Listener
resource "aws_lb_listener" "status_page" {
  load_balancer_arn = aws_lb.production.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.production_alb_tg.arn
  }
}