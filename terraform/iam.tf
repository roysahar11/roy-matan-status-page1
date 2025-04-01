# ECS Task Execution Role
resource "aws_iam_role" "production_task_execution_role" {
  name = "roymatan-status-page-task-execution-role"

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
    Name  = "roymatan-status-page-task-execution-role"
    Owner = "roysahar"
  }
}

# ECS task execution Policy
resource "aws_iam_role_policy_attachment" "production_task_execution_role_policy" {
  role       = aws_iam_role.production_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
} 

# IAM policy for ECS task to access the status-page secret
resource "aws_iam_role_policy" "production_secrets_access" {
  name = "ecs-task-secrets-access"
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
        Resource = [aws_secretsmanager_secret.production_secret.arn]
      }
    ]
  })
}
