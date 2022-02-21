variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
# variable "subnet_cidr" {
#   type = list(any)
#   default = [
#     "10.0.2.0/24", "10.0.3.0/24", "10.0.1.0/24"
#   ]
# }
# variable "azs"{
#   type = list
#   default = ["ap-south-1a","ap-south-1b", "ap-south-1c" ]

# }
data "aws_availability_zones" "available" {
  state = "available"
}



