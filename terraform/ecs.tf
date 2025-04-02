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
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.production_task_execution_role.arn
  task_role_arn           = aws_iam_role.production_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "status-page"
      image     = "${aws_ecr_repository.status_page.repository_url}:0.0.1"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      command = ["gunicorn", "--config", "/opt/status-page/docker/gunicorn.py", "statuspage.wsgi:application"]
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
          value = "[${aws_lb.production.dns_name}]"
        },
        {
          name  = "REDIS_SKIP_TLS_VERIFY"
          value = "true"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/roymatan-status-page"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
      secrets = [
        {
          name      = "POSTGRES_DB_NAME"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:POSTGRES_DB_NAME::AWSCURRENT"
        },
        {
          name      = "POSTGRES_USER"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:POSTGRES_USER::AWSCURRENT"
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:POSTGRES_PASSWORD::AWSCURRENT"
        },
        {
          name      = "SECRET_KEY"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:SECRET_KEY::AWSCURRENT"
        },
        {
          name      = "ADMIN_NAME"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:ADMIN_NAME::AWSCURRENT"
        },
        {
          name      = "ADMIN_EMAIL"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:ADMIN_EMAIL::AWSCURRENT"
        },
        {
          name      = "DJANGO_SUPERUSER_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:DJANGO_SUPERUSER_PASSWORD::AWSCURRENT"
        },
        {
          name      = "DJANGO_SUPERUSER_USERNAME"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:DJANGO_SUPERUSER_USERNAME::AWSCURRENT"
        },
        {
          name      = "DJANGO_SUPERUSER_EMAIL"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:DJANGO_SUPERUSER_EMAIL::AWSCURRENT"
        },
        {
          name      = "REDIS_AUTH_TOKEN"
          valueFrom = "${aws_secretsmanager_secret.production_secret.arn}:REDIS_AUTH_TOKEN::AWSCURRENT"
        }
      ]
    }
  ])

  depends_on = [
    aws_db_instance.production_rds,
    aws_elasticache_cluster.production_redis,
    aws_vpc.production_vpc,
    aws_subnet.production_private_a,
    aws_subnet.production_private_b,
    aws_ecr_repository.status_page,
    aws_secretsmanager_secret.production_secret,
    aws_secretsmanager_secret_version.production_secret_version,
    aws_vpc_endpoint.production_secretsmanager
  ]

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
    aws_ecs_task_definition.production_status_page_app,
    aws_lb.production
  ]

  network_configuration {
    subnets          = [aws_subnet.production_private_a.id, aws_subnet.production_private_b.id]
    security_groups  = [aws_security_group.status_page_app_production.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.production_alb_tg.arn
    container_name   = "status-page"
    container_port   = 8000
  }

  health_check_grace_period_seconds = 60

  tags = {
    Name  = "roymatan-status-page-app-service"
    Owner = "roysahar"
  }
} 