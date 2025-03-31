# Subnet group for RDS
resource "aws_db_subnet_group" "production" {
  name       = "roymatan-status-page-production-db-subnet-group"
  subnet_ids = [aws_subnet.production_private.id]

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
  engine_version      = "12.7"
  instance_class      = "db.t3.micro"
  username           = var.postgress_username
  password           = var.postgress_password
  db_name             = "statuspage"
  publicly_accessible = false
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.production.name
  vpc_security_group_ids = [aws_security_group.production_rds.id]
}
