# Output the service endpoint
output "status_page_endpoint" {
  value = "http://${aws_ecs_service.production_status_page_app.network_configuration[0].assign_public_ip ? "localhost" : "private"}:80"
  description = "The endpoint to access Roy Matan Status Page"
} 

output "rds_endpoint" {
  value       = aws_db_instance.production_rds.endpoint
  description = "The DNS name of the RDS instance"
}

output "redis_endpoint" {
  value       = "${aws_elasticache_replication_group.production_redis.primary_endpoint_address}:${aws_elasticache_replication_group.production_redis.port}"
  description = "The endpoint of the Redis cluster"
}

