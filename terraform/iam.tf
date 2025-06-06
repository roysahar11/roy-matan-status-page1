### ECS Task Execution Role
resource "aws_iam_role" "production_task_execution_role" {
  name = "roymatan-status-page-production-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name  = "roymatan-status-page-production-task-execution-role"
    Owner = "roysahar"
  }
}

# AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "production_task_execution_role_policy" {
  role       = aws_iam_role.production_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECR repository access policy
resource "aws_iam_role_policy" "production_ecr_access" {
  name = "roymatan-status-page-production-ecr-access"
  role = aws_iam_role.production_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = [
          aws_ecr_repository.status_page.arn
        ]
      }
    ]
  })
}

# Secrets Manager access policy for task execution role
resource "aws_iam_role_policy" "production_execution_secrets_access" {
  name = "roymatan-status-page-execution-secrets-access"
  role = aws_iam_role.production_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.production_secret.arn
        ]
      }
    ]
  })
}

# CloudWatch Logs access policy
resource "aws_iam_role_policy" "production_cloudwatch_logs_access" {
  name = "roymatan-status-page-production-cloudwatch-logs-access"
  role = aws_iam_role.production_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

### ECS Task Role
resource "aws_iam_role" "production_task_role" {
  name = "roymatan-status-page-production-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name  = "roymatan-status-page-production-task-role"
    Owner = "roysahar"
  }
}

# Task role policy for runtime permissions
resource "aws_iam_role_policy" "production_task_role_policy" {
  name = "roymatan-status-page-production-task-policy"
  role = aws_iam_role.production_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.production_secret.arn
        ]
      }
    ]
  })
}
