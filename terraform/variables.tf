variable "aws_endpoint" {
  description = "The endpoint URL"
  type        = string
  default     = "http://localhost:4566"
}

variable "postgress_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "postgress_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
} 