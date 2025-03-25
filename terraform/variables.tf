#  endpoints {
#     ecs = "http://localhost:4566"
#     sts = "http://localhost:4566"
#     iam = "http://localhost:4566"
#     ec2 = "http://localhost:4566"
#     elasticloadbalancing = "http://localhost:4566"
#     route53 = "http://localhost:4566"
#     cloudwatch = "http://localhost:4566"
#   }

variable "aws_endpoint" {
    type = string 
    default = ""
    description = "aws endppoint"
}
