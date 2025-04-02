resource "aws_secretsmanager_secret" "production_secret" {
  name_prefix   = "roymatan-status-page-production-secret-"
  description = "Secret for storing sensitive data for the status page application"
  recovery_window_in_days = 0  # Set to 0 to allow deletion without waiting

  tags = {
    Name  = "roymatan-status-page-secret"
    Owner = "roysahar"
  }
}

# Create a secret version with initial value
resource "aws_secretsmanager_secret_version" "production_secret_version" {
  secret_id     = aws_secretsmanager_secret.production_secret.id
  secret_string = jsonencode(var.production_secret_values)
}