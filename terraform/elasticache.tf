# Parameter group for Redis
resource "aws_elasticache_parameter_group" "production_redis" {
  family = "redis6.x"
  name   = "roymatan-status-page-production-redis-params"
}

# Subnet group for ElastiCache
resource "aws_elasticache_subnet_group" "production_redis" {
  name       = "roymatan-status-page-production-redis-subnet-group"
  subnet_ids = [aws_subnet.production_private.id]

  tags = {
    Name  = "roymatan-status-page-production-redis-subnet-group"
    Owner = "roysahar"
  }
}

# ElastiCache Redis cluster
resource "aws_elasticache_cluster" "production_redis" {
  cluster_id           = "roymatan-status-page-production-redis"
  engine              = "redis"
  node_type           = "cache.t3.micro"
  num_cache_nodes     = 1
  parameter_group_name = aws_elasticache_parameter_group.production_redis.name
  port                = 6379
  security_group_ids  = [aws_security_group.production_redis.id]
  subnet_group_name   = aws_elasticache_subnet_group.production_redis.name

  tags = {
    Name  = "roymatan-status-page-production-redis"
    Owner = "roysahar"
  }
}
