# Subnet group for RDS
resource "aws_db_subnet_group" "production" {
  name       = "roymatan-status-page-production-db-subnet-group"
  subnet_ids = [aws_subnet.production_private_a.id, aws_subnet.production_private_b.id]

  tags = {
    Name  = "roymatan-status-page-production-db-subnet-group"
    Owner = "roysahar"
  }
}

resource "aws_db_instance" "production_rds" {
  identifier           = "roymatan-status-page-production-rds-postgress"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "postgres"
  engine_version      = "17.4"
  instance_class      = "db.t3.micro"
  username           = var.production_secret_values["POSTGRES_USER"]
  password           = var.production_secret_values["POSTGRES_PASSWORD"]
  db_name             = "statuspage"
  publicly_accessible = false
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.production.name
  vpc_security_group_ids = [aws_security_group.production_rds.id]

  depends_on = [
    aws_vpc.production_vpc
  ]

  tags = {
    Owner = "roysahar"
  }
}
