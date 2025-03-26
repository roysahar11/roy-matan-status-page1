
resource "aws_db_instance" "localstack_rds" {
  identifier           = "my-localstack-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "postgres"
  engine_version      = "12.7"
  instance_class      = "db.t3.micro"
  username           = "admin"
  password           = "password123"
  publicly_accessible = true
  skip_final_snapshot = true
}