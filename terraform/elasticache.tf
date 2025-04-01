# Parameter group for Redis
resource "aws_elasticache_parameter_group" "production_redis" {
  family = "redis6.x"
  name   = "roymatan-status-page-production-redis-params"
}

# Subnet group for ElastiCache
resource "aws_elasticache_subnet_group" "production_redis" {
  name       = "roymatan-status-page-production-redis-subnet-group"
  subnet_ids = [aws_subnet.production_private_a.id, aws_subnet.production_private_b.id]

  tags = {
    Name  = "roymatan-status-page-production-redis-subnet-group"
    Owner = "roysahar"
  }
}

# ElastiCache Redis replication group (multi-node)
resource "aws_elasticache_replication_group" "production_redis" {
  replication_group_id = "roymatan-status-page-redis-rg"
  description         = "Redis cluster for Status Page"
  engine             = "redis"
  engine_version     = "6.x"
  node_type          = "cache.t3.micro"
  num_cache_clusters = 2
  parameter_group_name = aws_elasticache_parameter_group.production_redis.name
  port               = 6379
  security_group_ids = [aws_security_group.production_redis.id]
  subnet_group_name  = aws_elasticache_subnet_group.production_redis.name
  transit_encryption_enabled = true
  auth_token        = jsondecode(aws_secretsmanager_secret_version.production_secret_version.secret_string)["REDIS_AUTH_TOKEN"]

  tags = {
    Name  = "roymatan-status-page-production-redis-replication-group"
    Owner = "roysahar"
  }
}