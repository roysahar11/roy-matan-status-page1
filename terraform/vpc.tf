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