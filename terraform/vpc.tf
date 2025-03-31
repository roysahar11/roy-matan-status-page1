# Create VPC for ECS tasks
resource "aws_vpc" "production_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name  = "roymatan-status-page-production-vpc"
    Owner = "roysahar"
  }
}

# Create public subnet
resource "aws_subnet" "production_public" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name  = "roymatan-status-page-public-subnet"
    Owner = "roysahar"
  }
}

# Create private subnet for RDS
resource "aws_subnet" "production_private" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name  = "roymatan-status-page-private-subnet"
    Owner = "roysahar"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "production_igw" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name  = "roymatan-status-page-igw"
    Owner = "roysahar"
  }
}

# Route table for public subnet
resource "aws_route_table" "production_public" {
  vpc_id = aws_vpc.production_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production_igw.id
  }

  tags = {
    Name  = "roymatan-status-page-public-rt"
    Owner = "roysahar"
  }
}

# Route table for private subnet
resource "aws_route_table" "production_private" {
  vpc_id = aws_vpc.production_vpc.id

  tags = {
    Name  = "roymatan-status-page-private-rt"
    Owner = "roysahar"
  }
}

# Associate route table with public subnet
resource "aws_route_table_association" "production_public" {
  subnet_id      = aws_subnet.production_public.id
  route_table_id = aws_route_table.production_public.id
}

# Associate route table with private subnet
resource "aws_route_table_association" "production_private" {
  subnet_id      = aws_subnet.production_private.id
  route_table_id = aws_route_table.production_private.id
} 