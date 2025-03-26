# ECS Task Execution Role
resource "aws_iam_role" "status_page_task_execution_role" {
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

# Attach the required policy for ECS task execution
resource "aws_iam_role_policy_attachment" "status_page_task_execution_role_policy" {
  role       = aws_iam_role.status_page_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
} 