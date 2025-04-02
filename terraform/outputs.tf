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
  description = "The Redis endpoint"
  value       = "${aws_elasticache_cluster.production_redis.cache_nodes[0].address}:${aws_elasticache_cluster.production_redis.port}"
}

output "ecr_repository_uri" {
  description = "The URI of the ECR repository"
  value       = aws_ecr_repository.status_page.repository_url
}

output "ecr_push_commands" {
  description = "Commands to tag and push an image to the ECR repository"
  value = {
    tag_command    = "docker tag your-image:tag ${aws_ecr_repository.status_page.repository_url}:tag"
    push_command   = "docker push ${aws_ecr_repository.status_page.repository_url}:tag"
    login_command  = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.status_page.repository_url}"
  }
}

