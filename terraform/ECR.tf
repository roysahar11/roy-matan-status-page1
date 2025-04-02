# ECR Repository
resource "aws_ecr_repository" "status_page" {
  name                 = "roymatan-status-page"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    ignore_changes = [name]
    prevent_destroy = true
  }

  tags = {
    Name  = "roymatan-status-page-repo"
    Owner = "roysahar"
  }
}
