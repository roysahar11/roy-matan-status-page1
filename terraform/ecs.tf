
resource "aws_ecs_cluster" "status_page_cluster" {
  name = "roymatan-status-page-production-cluster"

  tags = {
    Name  = "roymatan-status-page-production-cluster"
    Owner = "roysahar"
  }
}

# ECS Task Definition for nginx

resource "aws_ecs_task_definition" "status_page_nginx" {
  family                   = "roymatan-status-page-nginx"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.status_page_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name  = "roymatan-status-page-nginx-task"
    Owner = "roysahar"
  }
}

# ECS Service
resource "aws_ecs_service" "status_page_nginx" {
  name            = "roymatan-status-page-nginx-service"
  cluster         = aws_ecs_cluster.status_page_cluster.id
  task_definition = aws_ecs_task_definition.status_page_nginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  depends_on = [aws_ecs_cluster.status_page_cluster]

  network_configuration {
    subnets          = [aws_subnet.status_page_public.id]
    security_groups  = [aws_security_group.status_page_nginx.id]
    assign_public_ip = true
  }

  tags = {
    Name  = "roymatan-status-page-nginx-service"
    Owner = "roysahar"
  }
}
