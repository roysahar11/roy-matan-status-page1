# Security group for ElastiCache Redis


# Subnet group for ElastiCache
resource "aws_elasticache_subnet_group" "production_redis" {
  name       = "roymatan-status-page-production-redis-subnet-group"
  subnet_ids = [aws_subnet.status_page_public.id]

  tags = {
    Name  = "roymatan-status-page-redis-subnet-group"
    Owner = "roysahar"
  }
}

# ElastiCache Redis cluster
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roymatan-status-page-production-redis"
  engine              = "redis"
  node_type           = "cache.t3.micro"
  num_cache_nodes     = 1
  parameter_group_family = "redis6.x"
  port                = 6379
  security_group_ids  = [aws_security_group.production_redis.id]
  subnet_group_name   = aws_elasticache_subnet_group.production_redis.name

  tags = {
    Name  = "roymatan-status-page-production-redis"
    Owner = "roysahar"
  }
}
