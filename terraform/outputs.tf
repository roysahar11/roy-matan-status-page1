# Output the service endpoint
output "status_page_endpoint" {
  value = "http://${aws_ecs_service.status_page_nginx.network_configuration[0].assign_public_ip ? "localhost" : "private"}:80"
  description = "The endpoint to access Roy Matan Status Page"
}
