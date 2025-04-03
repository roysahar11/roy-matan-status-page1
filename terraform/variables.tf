# variable "aws_endpoint" {
#   description = "The endpoint URL"
#   type        = string
#   default     = "http://localhost:4566"
# }

# variable "postgress_username" {
#   description = "Username for the RDS instance"
#   type        = string
#   default     = "admin"
# }

# variable "postgress_password" {
#   description = "Password for the RDS instance"
#   type        = string
#   sensitive   = true
# } 

# Define variables for secret values
variable "production_secret_values" {
  description = "Map of secret key-value pairs"
  type        = map(string)
  sensitive   = true
}

variable "image_tag" {
  description = "The image tag to use for ECS deployment"
  type        = string
}