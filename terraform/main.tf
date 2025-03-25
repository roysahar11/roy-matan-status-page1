terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ecs = "http://localhost:4566"
    sts = "http://localhost:4566"
    iam = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    elasticloadbalancing = "http://localhost:4566"
    route53 = "http://localhost:4566"
    cloudwatch = "http://localhost:4566"
  }
}

resource "aws_ecs_cluster" "status_page_cluster" {
  name = "roymatan-status-page-production-cluster"

  tags = {
    Name  = "roymatan-status-page-production-cluster"
    Owner = "roysahar"
  }
}

# Create VPC for ECS tasks
resource "aws_vpc" "status_page_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name  = "roymatan-status-page-production-vpc"
    Owner = "roysahar"
  }
}

# Create public subnet
resource "aws_subnet" "status_page_public" {
  vpc_id            = aws_vpc.status_page_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name  = "roymatan-status-page-public-subnet"
    Owner = "roysahar"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "status_page_igw" {
  vpc_id = aws_vpc.status_page_vpc.id

  tags = {
    Name  = "roymatan-status-page-igw"
    Owner = "roysahar"
  }
}

# Route table for public subnet
resource "aws_route_table" "status_page_public" {
  vpc_id = aws_vpc.status_page_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.status_page_igw.id
  }

  tags = {
    Name  = "roymatan-status-page-public-rt"
    Owner = "roysahar"
  }
}

# Associate route table with public subnet
resource "aws_route_table_association" "status_page_public" {
  subnet_id      = aws_subnet.status_page_public.id
  route_table_id = aws_route_table.status_page_public.id
}

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

# Output the service endpoint
output "status_page_endpoint" {
  value = "http://${aws_ecs_service.status_page_nginx.network_configuration[0].assign_public_ip ? "localhost" : "private"}:80"
  description = "The endpoint to access Roy Matan Status Page"
}
