resource "aws_secretsmanager_secret" "production_secret" {
  name        = "roymatan-status-page-secret"
  description = "Secret for storing sensitive data for the status page application"
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