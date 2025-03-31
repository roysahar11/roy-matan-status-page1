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
  publicly_accessible = true
  skip_final_snapshot = true
}
