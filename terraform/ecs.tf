resource "aws_ecs_cluster" "status_page_production_cluster" {
  name = "roymatan-status-page-production-cluster"

  tags = {
    Name  = "roymatan-status-page-production-cluster"
    Owner = "roysahar"
  }
}


# ECS Task Definition for status page
resource "aws_ecs_task_definition" "production_status_page_app" {
  family                   = "roymatan-status-page-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.production_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "status-page"
      image     = "python:3.10-slim"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "POSTGRES_HOST"
          value = aws_db_instance.production_rds.endpoint
        },
        {
          name  = "POSTGRES_PORT"
          value = "5432"
        },
        {
          name  = "REDIS_HOST"
          value = aws_elasticache_cluster.production_redis.cache_nodes[0].address
        },
        {
          name  = "REDIS_PORT"
          value = tostring(aws_elasticache_cluster.production_redis.port)
        },
        {
          name  = "ALLOWED_HOSTS"
          value = "[${aws_ecs_service.production_status_page_app.public_ip}]"
        }
      ]
      secrets = [
        {
          name      = "POSTGRES_DB_NAME"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        },
        {
          name      = "POSTGRES_USER"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        },
        {
          name      = "POSTGRESS_PASSWORD"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        },
        {
          name      = "SECRET_KEY"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        },
        {
          name      = "ADMIN_NAME"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        },
        {
          name      = "ADMIN_EMAIL"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        },
        {
          name      = "DJANGO_SUPERUSER_PASSWORD"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        },
        {
          name      = "DJANGO_SUPERUSER_USERNAME"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        },
        {
          name      = "DJANGO_SUPERUSER_EMAIL"
          valueFrom = aws_secretsmanager_secret.production_secret.arn
        }
      ]
    }
  ])

  tags = {
    Name  = "roymatan-status-page-production-app-task"
    Owner = "roysahar"
  }
}

# ECS Service
resource "aws_ecs_service" "production_status_page_app" {
  name            = "roymatan-status-page-production-app"
  cluster         = aws_ecs_cluster.status_page_production_cluster.id
  task_definition = aws_ecs_task_definition.production_status_page_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  depends_on = [
    aws_ecs_cluster.status_page_production_cluster,
    aws_db_instance.production_rds,
    aws_elasticache_cluster.production_redis
  ]

  network_configuration {
    subnets          = [aws_subnet.production_public.id]
    security_groups  = [aws_security_group.status_page_app_production.id]
    assign_public_ip = true
  }

  tags = {
    Name  = "roymatan-status-page-app-service"
    Owner = "roysahar"
  }
} 