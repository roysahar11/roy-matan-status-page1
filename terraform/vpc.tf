# Production environment VPC
resource "aws_vpc" "production_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name  = "roymatan-status-page-production-vpc"
    Owner = "roysahar"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name  = "roymatan-status-page-nat-eip"
    Owner = "roysahar"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.production_public_a.id  # Place NAT Gateway in public subnet

  tags = {
    Name  = "roymatan-status-page-nat-gateway"
    Owner = "roysahar"
  }
}

# Public Subnets
resource "aws_subnet" "production_public_a" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name  = "roymatan-status-page-public-subnet-a"
    Owner = "roysahar"
  }
}
resource "aws_subnet" "production_public_b" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name  = "roymatan-status-page-public-subnet-b"
    Owner = "roysahar"
  }
}


# Private Subnets
resource "aws_subnet" "production_private_a" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name  = "roymatan-status-page-private-subnet-a"
    Owner = "roysahar"
  }
}
resource "aws_subnet" "production_private_b" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name  = "roymatan-status-page-private-subnet-b"
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

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name  = "roymatan-status-page-private-rt"
    Owner = "roysahar"
  }
}

# Associate route table with public subnets
resource "aws_route_table_association" "production_public_a" {
  subnet_id      = aws_subnet.production_public_a.id
  route_table_id = aws_route_table.production_public.id
}
resource "aws_route_table_association" "production_public_b" {
  subnet_id      = aws_subnet.production_public_b.id
  route_table_id = aws_route_table.production_public.id
}

# Associate route table with private subnets
resource "aws_route_table_association" "production_private_a" {
  subnet_id      = aws_subnet.production_private_a.id
  route_table_id = aws_route_table.production_private.id
} 
resource "aws_route_table_association" "production_private_b" {
  subnet_id      = aws_subnet.production_private_b.id
  route_table_id = aws_route_table.production_private.id
} 